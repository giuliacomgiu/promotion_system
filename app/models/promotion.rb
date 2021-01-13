class Promotion < ApplicationRecord
  has_many :coupons, dependent: :destroy

  validates :name, :code, :discount_rate,
            :coupon_quantity, :expiration_date,
            presence: { message: 'não pode ficar em branco' }

  validates :code, uniqueness: { case_sensitive: false }

  def code
    self[:code].upcase if self[:code].present?
  end

  def code=(val)
    self[:code] = val.upcase
  end

  def issue_coupons!
    codes =
      (1..coupon_quantity).map do |number|
        { code: "#{code}-#{'%04d' % number}" }
      end
    coupons
      .create_with(created_at: Time.now, updated_at: Time.now)
      .insert_all!(codes)
  end
end
