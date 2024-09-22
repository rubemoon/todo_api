class SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      token = generate_jwt_token(resource)
      log_jwt_token(token)
      log_user_info(resource)
      render_success_response(resource, token)
    else
      render_failure_response
    end
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

  def log_user_info(resource)
    Rails.logger.info "User Info: #{resource.inspect}"
  end

  def render_success_response(resource, token)
    render json: {
      message: "Logged in successfully",
      user: {
        id: resource.id,
        email: resource.email
      },
      token: token
    }, status: :ok
  end

  def render_failure_response
    render json: {
      message: "Login failed",
      errors: resource.errors.full_messages
    }, status: :unauthorized
  end
end
