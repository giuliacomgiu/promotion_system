class Coupon < ApplicationRecord
  belongs_to :promotion

  validates :code, presence: true

  enum status: { active: 0, archived: 1, burned: 2 }

  def name
    "#{code} (#{Coupon.human_attribute_name("status.#{status}")})"
  end

  def as_json(options = {})
    super({ methods: %i[discount_rate expiration_date maximum_discount],
            only: %i[] }.merge(options))
  end

  private

  def discount_rate
    promotion.discount_rate
  end

  def expiration_date
    I18n.l(promotion.expiration_date)
  end

  def maximum_discount
    "R$ #{promotion.maximum_discount}"
  end
end
