module Api
  module V1
    class ApiController < ActionController::API
      delegate :l, :t, to: :I18n

      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      private

      # TODO: Proper json formatting
      def not_found
        render json: t('.not_found'), status: :not_found
      end
    end
  end
end
