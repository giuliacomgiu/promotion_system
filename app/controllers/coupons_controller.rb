class CouponsController < ApplicationController
  before_action :authenticate_user!

  def archive
    @coupon = Coupon.find(params[:id])
    flash[:success] = t('.success') if @coupon.archived!
    redirect_to @coupon.promotion
  end

  def reactivate
    @coupon = Coupon.find(params[:id])
    flash[:success] = t('.success') if @coupon.active!
    redirect_to @coupon.promotion
  end

  def search
    @coupons = Coupon.where('code LIKE ?', "%#{params[:query]}%")
  end
end
