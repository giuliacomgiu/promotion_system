module Api
  module V1
    class CouponsController < ApiController
      before_action :set_coupon, only: %i[show burn]
      before_action :check_order_code_presence, :check_product_category_code_presence,
                    :validate_product_category_code, only: :burn

      def show
        render json: @coupon, status: :ok
      end

      def burn
        validate_product_category_code
        @coupon.burn!(coupon_order)
        render json: t(:success, scope: %i[coupons api v1 burn]), status: :ok
      end

      private

      def set_coupon
        @coupon = Coupon.find_by!(code: params[:code])
      end

      def check_order_code_presence
        return if coupon_order.present?

      rescue ActionController::ParameterMissing
        render json: t(:missing_order_code, scope: %i[coupons api v1 burn]), status: 422
      end

      def check_product_category_code_presence
        return if coupon_product_category.present?

      rescue ActionController::ParameterMissing
        render json: t(:missing_product_category_code, scope: %i[coupons api v1 burn]), status: 422
      end

      def validate_product_category_code
        return if @coupon.product_categories_codes.include? coupon_product_category

        render json: 'Categoria de produto inválida para este cupom', status: :bad_request
      end

      def coupon_order
        params
          .require(:order)
          .permit(:code)
          .fetch(:code)
          .upcase
      end

      def coupon_product_category
        params
          .require(:product_category)
          .permit(:code)
          .fetch(:code)
          .upcase
      end
    end
  end
end

# or class Api::V1::CouponsController < Api::V1::ApiController
