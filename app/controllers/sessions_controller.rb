class SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    token = generate_jwt_token(resource)
    log_jwt_token(token)
    render_success_response(resource, token)
  end

  def respond_to_on_destroy
    head :no_content
  end

  def generate_jwt_token(resource)
    Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
  end

  def log_jwt_token(token)
    Rails.logger.info "JWT Token: #{token}"
  end

  def render_success_response(resource, token)
    render json: {
      message: "Logged in successfully",
      user: resource,
      token: token
    }, status: :ok
  end
end
