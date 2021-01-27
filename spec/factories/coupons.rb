FactoryBot.define do
  factory :coupon do
    association :promotion
    sequence(:code){ |n| "#{promotion.code}-000#{n}" }
    status { :active }

    trait :burned do
      status { :burned }
    end

    trait :archived do
      status { :archived }
    end
  end
end