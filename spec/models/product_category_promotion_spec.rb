require 'rails_helper'

RSpec.describe ProductCategoryPromotion, type: :model do
  context 'promotion deletion' do
    it 'associations are deleted, but product category still exists' do
      product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
      promotion = Promotion.create!(product_categories: [product], name: 'Natal',
                                    code: 'NATAL20', discount_rate: 10, maximum_discount: 10,
                                    coupon_quantity: 100, expiration_date: '22/12/2033')
      
      join_elements = ProductCategoryPromotion.find_by(promotion: promotion)
      promotion.destroy!

      expect(product.reload).not_to be nil
      expect(promotion.destroyed?).to be true
      expect{ join_elements.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
  
  context 'product category deletion' do
    it 'promotion has multiple product categories, so its not deleted' do
      products = ProductCategory.create!([{name: 'Wordpress', code: 'WORDP'},
                                          name: 'E-mail', code: 'EMAIL'])
      promotion = Promotion.create!(product_categories: products, name: 'Natal',
                                    code: 'NATAL20', discount_rate: 10, maximum_discount: 10,
                                    coupon_quantity: 100, expiration_date: '22/12/2033')
      
      products[0].destroy

      join_element = ProductCategoryPromotion.find_by(promotion: promotion)
      expect(products[0].destroyed?).to be true 
      expect(promotion.reload.product_categories.names).to include 'E-mail'
      expect(promotion.product_categories.names).not_to include 'Wordpress'
      expect(join_element.product_category).not_to eq products[0]
      expect(join_element.product_category).to eq products[1]
    end

    it 'promotion has only one product_category, so its deleted' do
      product = ProductCategory.create!(name: 'Wordpress', code: 'WORDP')
      promotion = Promotion.create!(product_categories: [product], name: 'Natal',
                                    code: 'NATAL20', discount_rate: 10, maximum_discount: 10,
                                    coupon_quantity: 100, expiration_date: '22/12/2033')

      product.destroy

      join_element = ProductCategoryPromotion.find_by(promotion: promotion)
      expect(join_element).to be nil
      expect{promotion.reload}.to raise_error ActiveRecord::RecordNotFound
      expect{product.reload}.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
