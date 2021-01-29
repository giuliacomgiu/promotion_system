FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "teste#{n}@locaweb.com.br" }
    password { 'f4k3p455w0rd' }
  end
end