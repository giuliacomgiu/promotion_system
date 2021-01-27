FactoryBot.define do
  factory :product_category do
    name { 'Wordpress' }
    sequence(:code) { |n| "WORDP#{n}" }
  end
end