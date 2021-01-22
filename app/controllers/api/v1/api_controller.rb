module Api
  module V1
    class ApiController < ActionController::API
      delegate :l, :t, to: :I18n

      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      private

      def not_found
        render json: 'Não encontrado', status: :not_found
      end
    end
  end
end
