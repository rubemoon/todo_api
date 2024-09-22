# frozen_string_literal: true

class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  protect_from_forgery with: :null_session

  # Skip CSRF token verification for the execute action
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

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      variables_param.present? ? JSON.parse(variables_param) : {}
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def current_user
    return unless request.headers["Authorization"].present?

    token = request.headers["Authorization"].split(" ").last
    decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: "HS256" }).first
    User.find(decoded_token["user_id"])
  rescue JWT::DecodeError
    nil
  end

  def handle_error(error)
    if Rails.env.development?
      handle_error_in_development(error)
    else
      render json: { errors: [ { message: error.message } ] }, status: 500
    end
  end

  def handle_error_in_development(error)
    logger.error error.message
    logger.error error.backtrace.join("\n")

    render json: { errors: [ { message: error.message, backtrace: error.backtrace } ] }, status: 500
  end
end
