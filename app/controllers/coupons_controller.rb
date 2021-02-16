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
    search_data = params[:query].strip
    redirect_back fallback_location: root_path, alert: t('.blank_field') if search_data.empty?

    @search_results = Coupon.where('code = (?)', search_data)
  end
end
