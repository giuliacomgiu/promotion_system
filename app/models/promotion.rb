class Promotion < ApplicationRecord
  has_many :coupons, dependent: :destroy
  has_many :product_category_promotions, dependent: :delete_all
  has_many :product_categories, through: :product_category_promotions do
    def names
      proxy_association.owner
                       .product_categories
                       .map(&:name)
                       .to_sentence(two_words_connector: ', ', last_word_connector: ' e ')
    end

    def codes
      proxy_association.owner
                       .product_categories
                       .map(&:code)
    end
  end

  validates :name, :code, :discount_rate, :maximum_discount,
            :coupon_quantity, :expiration_date, :product_category_ids,
            presence: true

  validates :code, uniqueness: { case_sensitive: false }

  def code
    self[:code].upcase if self[:code].present?
  end

  def code=(val)
    self[:code] = val.upcase
  end

  def expired?
    Time.now > expiration_date
  end

  def not_expired?
    !expired?
  end

  def issue_coupons!
    raise 'Cupons já foram gerados!' if coupons.any?
    raise 'A promoção já expirou' if expired?

    coupons
      .create_with(created_at: Time.now, updated_at: Time.now)
      .insert_all!(coupon_codes)
  end

  private

  def coupon_codes
    (1..coupon_quantity).map do |amount|
      { code: "#{code}-#{'%04d' % amount}" }
    end
  end
end
