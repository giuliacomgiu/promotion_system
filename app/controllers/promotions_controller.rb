class PromotionsController < ApplicationController
  def index
    @promotions = Promotion.all
  end

  def show
    @promotion = Promotion.find(params[:id])
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(promotion_params)
    redirect_to @promotion if @promotion.save
  end

  def promotion_params
    params
      .require(:promotion)
      .permit(:name, :description, :code, :discount_rate,
              :expiration_date, :coupon_quantity)
  end
end
