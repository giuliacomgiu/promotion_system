class PromotionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_promotion, only: %i[show edit update destroy approve issue_coupons]
  before_action :authorize_creator!, only: %i[edit]

  def index
    @promotions = Promotion.all
  end

  def show; end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(promotion_params.merge(creator: current_user))
    if @promotion.save
      redirect_to @promotion
    else
      render :new
    end
  end

  def edit; end

  def update
    if @promotion.update(promotion_params)
      redirect_to @promotion
    else
      render :edit
    end
  end

  def destroy
    @promotion.destroy
    redirect_to promotions_path
  end

  def approve
    @promotion.update(curator: current_user)
    redirect_to @promotion, success: t('.approve')
  end

  def issue_coupons
    @promotion.issue_coupons!
    redirect_to @promotion, success: t('.success')
  end

  def search
    if params[:query].empty?
      redirect_to promotions_path, alert: t('.blank_field')
    else
      query_param = "%#{params[:query]}%"
      @promotions = Promotion.where('name LIKE ? OR description LIKE ?',
                                        query_param, query_param)
    end
  end

  private

  def set_promotion
    @promotion = Promotion.find(params[:id])
  end

  def promotion_params
    params
      .require(:promotion)
      .permit(:name, :description, :code, :discount_rate, :expiration_date,
              :coupon_quantity, :maximum_discount, product_category_ids: [])
  end

  def authorize_creator!
    return if @promotion.creator.eql?(current_user) && @promotion.curator.nil?

    redirect_back fallback_location: root_url, status: :forbidden, alert: 'Forbidden'
  end
end
