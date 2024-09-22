class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    if resource.save
      attach_profile_image(resource)
      render_resource(resource)
    else
      render_resource_errors(resource)
    end
  end

  private

  def attach_profile_image(resource)
    if params[:user][:profile_image].present?
      resource.profile_image.attach(params[:user][:profile_image])
    end
  end

  def render_resource(resource)
    render json: resource, status: :created
  end

  def render_resource_errors(resource)
    render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
  end
end
