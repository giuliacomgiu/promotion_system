class Coupon < ApplicationRecord
  belongs_to :promotion

  validates :code, presence: true
  validates :order, presence: true, on: :burn!

  enum status: { active: 0, archived: 1, burned: 2 }

  delegate :discount_rate, :expiration_date, :maximum_discount, to: :promotion

  def burn!(order)
    update!(order: order, status: :burned)
  end

  def as_json(options = {})
    super(default_json_options(options))
      .merge(api_status)
      .merge(api_data)
  end

  def name
    "#{code} (#{Coupon.human_attribute_name("status.#{status}")})"
  end

  private

  def default_json_options(options)
    { only: %i[] }.merge(options)
  end

  def api_status
    if promotion.expired?
      return { 'status' => 'expired' } if active?
      return { 'status' => 'burned, expired' } if burned?
    else
      return { 'status' => 'valid' } if active?
      return { 'status' => 'burned' } if burned?
    end
  end

  def api_data
    { discount_rate: discount_rate,
      expiration_date: I18n.l(expiration_date),
      maximum_discount: "R$ #{promotion.maximum_discount}" }
    # TODO: change maximum discount to I18n formatting, correct precision and separator
  end
end
