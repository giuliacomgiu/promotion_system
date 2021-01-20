class ProductCategory < ApplicationRecord
  has_many :product_category_promotions
  has_many :promotions, through: :product_category_promotions

  validates :name, :code, presence: { message: 'não pode ficar em branco' }
  validates :code, uniqueness: { case_sensitive: false }

  def code
    self[:code].upcase if self[:code].present?
  end

  def code=(val)
    self[:code] = val.upcase
  end
end
