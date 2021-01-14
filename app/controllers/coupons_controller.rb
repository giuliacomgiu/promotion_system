class CouponsController < ApplicationController
  def archive
    @coupon = Coupon.find(params[:id])
    flash[:success] = t('.success') if @coupon.archived!
    redirect_to @coupon.promotion
  end
end
