class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render file: 'public/404.html', status: :not_found, formats: [:html]
  end
end
