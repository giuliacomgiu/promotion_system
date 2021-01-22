class Coupon < ApplicationRecord
  belongs_to :promotion

  validates :code, presence: true
  validates :order, presence: true, on: :burn!

  enum status: { active: 0, archived: 1, burned: 2 }

  def name
    "#{code} (#{Coupon.human_attribute_name("status.#{status}")})"
  end

  def discount_rate
    promotion.discount_rate
  end

  def expiration_date
    I18n.l(promotion.expiration_date)
  end

  def maximum_discount
    #TODO: change to I18n formatting, correct precision and separator
    "R$ #{promotion.maximum_discount}"
  end

  def burn!(order)
    update!(order: order, status: :burned)
  end

  def as_json(options = {})
    super(default_json_options(options)).merge!(coupon_json_status)
  end

  private

  def default_json_options(options)
    { methods: %i[discount_rate expiration_date maximum_discount],
      only: %i[] }.merge(options)
  end

  def coupon_json_status
    return { 'status' => 'valid' } if active? && promotion.not_expired?
    return { 'status' => 'burned' } if burned? && promotion.not_expired?
    return { 'status' => 'expired' } if active? && promotion.expired?
    return { 'status' => 'burned, expired' } if burned? && promotion.expired?
  end
end
