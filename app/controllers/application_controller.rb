class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render file: 'public/404.html', status: 404, formats: [:html]
  end
end
