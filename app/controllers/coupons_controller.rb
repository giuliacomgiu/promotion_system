class CouponsController < ApplicationController
  def archive
    @coupon = Coupon.find(params[:id])
    flash[:success] = 'Cupom arquivado com sucesso' if @coupon.archived!
    redirect_to @coupon.promotion
  end
end
