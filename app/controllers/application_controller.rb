class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: :json_request?
  include Devise::Controllers::Helpers

  # Skip CSRF verification for JSON requests
  skip_before_action :verify_authenticity_token, if: :json_request?

  private

  # Check if the request format is JSON
  def json_request?
    request.format.json?
  end

  # Ensure Devise doesn't override the CSRF settings for JSON requests
  def handle_unverified_request
    if json_request?
      render json: { error: "Invalid authenticity token" }, status: :unprocessable_entity
    else
      super
    end
  end
end
