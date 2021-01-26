FactoryBot.define do
  factory :promotion do
    name { 'Natal' }
    code { 'NATAL10' }
    discount_rate { 10 }
    coupon_quantity { 5 }
    maximum_discount { 50 }
    expiration_date { 1.day.from_now }
    association :creator, email: 'maria@locaweb.com.br', factory: :user

    transient do
      product_category_count { 1 }
    end

    trait :with_product_category do
      after(:build) do |promotion, evaluator|
        promotion.product_categories = create_list(:product_category, evaluator.product_category_count)
        promotion.save
      end
    end

    trait :approved do
      after(:build) do |promotion|
        promotion.curator = create(:user, email: 'dandara@locaweb.com.br')
        promotion.save
      end
    end
  end
end