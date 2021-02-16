require 'rails_helper'

RSpec.describe ProductCategoryPromotion, type: :model do
  context 'promotion deletion' do
    it 'associations are deleted, but product category still exists' do
      promotion = create :promotion, :with_product_category
      product = promotion.product_categories

      join_elements = ProductCategoryPromotion.find_by(promotion: promotion)
      promotion.destroy!

      expect(product.reload).not_to be nil
      expect(promotion.destroyed?).to be true
      expect { join_elements.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  context 'product category deletion' do
    it 'promotion has multiple product categories, so its not deleted' do
      promotion = create :promotion, :with_product_category, product_category_count: 2
      products = promotion.product_categories

      products[0].destroy
      promotion.reload

      join_element = ProductCategoryPromotion.find_by(promotion: promotion)
      expect(products[0].destroyed?).to be true
      expect(promotion.product_categories.codes).to include products[1].code
      expect(promotion.product_categories.codes).not_to include products[0].code
      expect(join_element.product_category).not_to eq products[0]
      expect(join_element.product_category).to eq products[1]
    end

    it 'promotion has only one product_category, so its deleted' do
      promotion = create :promotion, :with_product_category
      product = promotion.product_categories.first

      product.destroy

      join_element = ProductCategoryPromotion.find_by(promotion: promotion)
      expect(join_element).to be nil
      expect { promotion.reload }.to raise_error ActiveRecord::RecordNotFound
      expect { product.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
