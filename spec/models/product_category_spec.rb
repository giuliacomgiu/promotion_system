require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  context 'Validation' do
    it 'fields cant be blank' do
      product_category = ProductCategory.new
      product_category.valid?

      expect(product_category.errors.of_kind?(:name, :blank)).to be true
      expect(product_category.errors.of_kind?(:code, :blank)).to be true
    end

    it 'code must be unique' do
      ProductCategory.create!(name: 'test', code: 'CODE')
      product_category = ProductCategory.new(code: 'CODE')
      product_category.valid?

      expect(product_category.errors.of_kind?(:code, :taken)).to be true
    end

    it 'code is case insensitive' do
      ProductCategory.create!(name: 'test', code: 'CODE')
      product_category = ProductCategory.new(code: 'code')
      product_category.valid?

      expect(product_category.errors.of_kind?(:code, :taken)).to be true
    end
  end
end
