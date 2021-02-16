class ProductCategory < ApplicationRecord
  has_many :product_category_promotions, dependent: :delete_all
  has_many :promotions, through: :product_category_promotions

  validates :name, :code, presence: { message: 'não pode ficar em branco' }
  validates :code, uniqueness: { case_sensitive: false }

  before_destroy :destroy_promotion, prepend: true

  def code
    self[:code].upcase if self[:code].present?
  end

  def code=(val)
    self[:code] = val.upcase
  end

  def destroy_promotion
    promotions.each do |promotion|
      promotion.destroy unless promotion.product_categories.count > 1
    end
  end
end
