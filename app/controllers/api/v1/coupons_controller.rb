module Api
  module V1
    class CouponsController < ApiController
      before_action :set_coupon, only: %i[show burn]

      def show
        render json: @coupon, status: :ok
      end

      def burn
        @coupon.update(order: coupon_order_params[:code], status: :burned)
        render json: 'Cupom utilizado com sucesso', status: :ok
      rescue ActionController::ParameterMissing
        render json: 'Cupom só pode ser utilizado com código do pedido', status: 422
      end

      private

      def set_coupon
        @coupon = Coupon.find_by!(code: params[:code])
      end

      def coupon_order_params
        params.require(:order).permit(:code)
      end
    end
  end
end

# or class Api::V1::CouponsController < Api::V1::ApiController
