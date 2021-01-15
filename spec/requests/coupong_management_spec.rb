require 'rails_helper'

describe 'Coupon management' do
  context 'show' do
    it 'render coupon json with discount' do
      promotion = Promotion.create!(name: 'Pascoa', coupon_quantity: 5,
                                    discount_rate: 10, code: 'PASCOA10',
                                    expiration_date: 1.day.from_now)
      coupon = Coupon.create!(promotion: promotion, code: 'PASCOA10-0001')

      get "/api/v1/coupons/#{coupon.code}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(promotion.discount_rate.to_s)
      expect(response.body).to include(I18n.l(promotion.expiration_date))
      # expect(response.body).to include(promotion.maximum_discount.to_s)
    end
  end
end
