class ProductCategory < ApplicationRecord
  validates :name, :code, presence: { message: 'não pode ficar em branco' }
  validates :code, uniqueness: { case_sensitive: false }

  def code
    self[:code].upcase if self[:code].present?
  end

  def code=(val)
    self[:code] = val.upcase
  end
end
