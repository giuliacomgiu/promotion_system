module Helpers
  def create_promotion_with_product_category
    create :product_category do |product_category|
      create :promotion, product_categories: [product_category]
    end
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  # Uncomment if moving methods to Helper module
  # config.include Helpers
end
