FactoryBot.define do
  factory :promotion do
    name { 'Natal' }
    code { 'NATAL10' }
    discount_rate { 10 }
    coupon_quantity { 5 }
    maximum_discount { 50 }
    expiration_date { 1.day.from_now }
    association :product_categories
  end
end