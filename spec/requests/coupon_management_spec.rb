require 'rails_helper'

describe 'Coupon management' do
  context 'show' do
    it 'render coupon json with discount' do
      promotion = Promotion.create!(name: 'Pascoa', coupon_quantity: 5,
                                    discount_rate: 10, code: 'PASCOA10',
                                    expiration_date: 1.day.from_now, maximum_discount: 10)
      coupon = Coupon.create!(promotion: promotion, code: 'PASCOA10-0001')

      get "/api/v1/coupons/#{coupon.code}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(promotion.discount_rate.to_s)
      expect(response.body).to include(I18n.l(promotion.expiration_date))
      # expect(response.body).to include(promotion.maximum_discount.to_s)
    end

    xit 'render maximum discount ' do
    end

    it 'coupon not found' do
      get '/api/v1/coupons/1337'

      expect(response).to have_http_status(:not_found)
    end

    xit 'coupon has already expired' do
      promotion = Promotion.create!(name: 'Pascoa', coupon_quantity: 5,
                                    discount_rate: 10, code: 'PASCOA10',
                                    expiration_date: 1.day.from_now, maximum_discount: 10)
      coupon = Coupon.create!(promotion: promotion, code: 'PASCOA10-0001')
      promotion.update!(expiration_date: 1.day.ago)

      get "/api/v1/coupons/#{coupon.code}"

      expect(response).to have_http_status(200)
      expect(response).to include('Cupom já expirou')
      expect(response).to include('discount_rate')
    end

    xit 'coupon is archived' do
    end

    it 'order code cant be blank' do
      promotion = Promotion.create!(name: 'Pascoa', coupon_quantity: 5,
                                    discount_rate: 10, code: 'PASCOA10',
                                    expiration_date: 1.day.from_now, maximum_discount: 10)
      coupon = Coupon.create!(promotion: promotion, code: 'PASCOA10-0001')

      patch "/api/v1/coupons/#{coupon.code}/burn"

      expect(response).to have_http_status(422)
      expect(response.body).to include('Cupom só pode ser utilizado com código do pedido')
      expect(coupon.reload).to be_active
    end
  end

  context 'burn' do
    it 'change coupon status' do
      promotion = Promotion.create!(name: 'Pascoa', coupon_quantity: 5,
                                    discount_rate: 10, code: 'PASCOA10',
                                    expiration_date: 1.day.from_now, maximum_discount: 10)
      coupon = Coupon.create!(promotion: promotion, code: 'PASCOA10-0001')

      patch "/api/v1/coupons/#{coupon.code}/burn", params: { order: { code: 'ORDER123' } }

      expect(response).to have_http_status(200)
      expect(response.body).to include('Cupom utilizado com sucesso')
      expect(coupon.reload).to be_burned
      expect(coupon.reload.order).to eq 'ORDER123'
    end
  end
end
