# lib/json_web_token.rb

require "jwt"

class JsonWebToken
  SECRET_KEY = ENV["SECRET_KEY_BASE"]

  # Encodes a hash into a JWT token
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  # Decodes a JWT token and returns the payload
  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::DecodeError
    nil
  end
end
