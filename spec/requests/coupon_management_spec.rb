require 'rails_helper'

describe 'Coupon management' do
  context 'show' do
    it 'render coupon json successfully' do
      promotion = create :promotion, :with_product_category
      coupon = create :coupon, promotion: promotion

      get "/api/v1/coupons/#{coupon.code}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(promotion.discount_rate.to_s)
      expect(response.body).to include(I18n.l(promotion.expiration_date))
      expect(response.body).to include(promotion.maximum_discount.to_s)
    end

    it 'coupon not found' do
      get '/api/v1/coupons/1337'

      expect(response).to have_http_status(:not_found)
    end

    it 'coupon has already expired' do
      promotion = create :promotion, :with_product_category, :expired
      coupon = create :coupon, promotion: promotion

      get "/api/v1/coupons/#{coupon.code}"

      expect(response).to have_http_status(200)
      expect(response.body).to include('expired')
    end

    it 'coupon is burned' do
      promotion = create :promotion, :with_product_category
      coupon = create :coupon, :burned, promotion: promotion
      
      get "/api/v1/coupons/#{coupon.code}"

      expect(response).to have_http_status(200)
      expect(response.body).to include('burned')
    end

    it 'coupon is burned and expired' do
      promotion = create :promotion, :with_product_category, :expired
      coupon = create :coupon, :burned, promotion: promotion
      
      get "/api/v1/coupons/#{coupon.code}"

      expect(response).to have_http_status(200)
      expect(response.body).to include('burned')
      expect(response.body).to include('expired')
    end

    it 'order code cant be blank' do
      promotion = create :promotion, :with_product_category
      coupon = create :coupon, promotion: promotion

      patch "/api/v1/coupons/#{coupon.code}/burn"

      expect(response).to have_http_status(400)
      expect(response.body).to include('Cupom só pode ser utilizado com código do pedido')
      expect(coupon.reload).to be_active
    end
  end

  context 'burn' do
    it 'change coupon status' do
      promotion = create :promotion, :with_product_category
      coupon = create :coupon, promotion: promotion
      product_category = promotion.product_categories.first.code

      patch "/api/v1/coupons/#{coupon.code}/burn", params: { order: { code: 'ORDER123' }, 
                                                             product_category: { code: "#{product_category}" } }

      expect(response).to have_http_status(200)
      expect(response.body).to include('Cupom utilizado com sucesso')
      expect(coupon.reload).to be_burned
      expect(coupon.reload.order).to eq 'ORDER123'
    end

    it 'fails if product category code doesnt belong to the promotion' do
      promotion = create :promotion, :with_product_category
      coupon = create :coupon, promotion: promotion

      patch "/api/v1/coupons/#{coupon.code}/burn", params: { order: { code: 'ORDER123' }, 
                                                             product_category: { code: '1234' } }

      expect(response).to have_http_status(400)
      expect(response.body).to include('Categoria de produto inválida para este cupom')
      expect(coupon.reload).to be_active
      expect(coupon.reload.order).to be nil
    end

    it 'fails if order code is missing' do
      promotion = create :promotion, :with_product_category
      coupon = create :coupon, promotion: promotion
      product_category = promotion.product_categories.first.code

      patch "/api/v1/coupons/#{coupon.code}/burn", params: { product_category: { code: "#{product_category}" } }

      expect(response).to have_http_status(400)
      expect(response.body).to include('Cupom só pode ser utilizado com código do pedido')
      expect(coupon.reload).to be_active
    end

    it 'fails if product category code is missing' do
      promotion = create :promotion, :with_product_category
      coupon = create :coupon, promotion: promotion

      patch "/api/v1/coupons/#{coupon.code}/burn", params: { order: { code: 'ORDER123' } }

      expect(response).to have_http_status(400)
      expect(response.body).to include('Cupom só pode ser utilizado com código da categoria de produto')
      expect(coupon.reload).to be_active
    end

    xit 'fail if coupon has expired'
  end
end
