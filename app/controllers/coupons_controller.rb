class CouponsController < ApplicationController
  before_action :authenticate_user!

  def archive
    @coupon = Coupon.find(params[:id])
    redirect_to @coupon.promotion, success: t('.success') if @coupon.archived!
  end

  def reactivate
    @coupon = Coupon.find(params[:id])
    redirect_to @coupon.promotion, success: t('.success') if @coupon.active!
  end

  def search
    @search_results = Coupon.where('code = upper(?)', params[:query].upcase)
  end
end
