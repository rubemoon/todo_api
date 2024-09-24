class GraphqlController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token, only: [ :execute ]

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = { current_user: current_user }

    result = TodoApiSchema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )

    render json: result
  rescue StandardError => e
    handle_error(e)
  end

  private

  def prepare_variables(variables_param)
    case variables_param
    when String
      variables_param.present? ? JSON.parse(variables_param) : {}
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash
    else
      {}
    end
  end

  def current_user
    return unless request.headers["Authorization"].present?

    token = request.headers["Authorization"].split(" ").last
    begin
      decoded_token = JsonWebToken.decode(token)
      User.find_by(id: decoded_token["user_id"]) if decoded_token
    rescue JWT::DecodeError
      nil
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def handle_error(error)
    render json: { errors: [ { message: error.message } ] }, status: 500
  end
end
