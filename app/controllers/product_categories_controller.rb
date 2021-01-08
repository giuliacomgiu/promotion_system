class ProductCategoriesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @product_categories = ProductCategory.all
  end
end
