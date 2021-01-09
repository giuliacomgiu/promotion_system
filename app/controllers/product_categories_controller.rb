class ProductCategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @product_categories = ProductCategory.all
  end

  def new
    @product_category = ProductCategory.new
  end

  def create
    @product_category = ProductCategory.new(product_category_params)

    if @product_category.save
      redirect_to @product_category
    else
      render :new
    end
  end

  def show
    @product_category = ProductCategory.find(params[:id])
  end

  def destroy
    redirect_to action: 'index' if ProductCategory.find(params[:id]).destroy
  end

  private

  def product_category_params
    params.require(:product_category).permit(:name, :code)
  end
end
