# lib/json_web_token.rb

require "jwt"

class JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base

  # Encodes a hash into a JWT token
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    puts "Encoding payload: #{payload}" # Debug statement
    JWT.encode(payload, SECRET_KEY)
  end

  # Decodes a JWT token and returns the payload
  def self.decode(token)
    puts "Decoding Token: #{token}" # Debug statement
    if SECRET_KEY.nil?
      puts "SECRET_KEY is nil" # Debug statement
      return nil
    end
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::DecodeError => e
    puts "JWT Decode Error: #{e.message}" # Debug statement
    nil
  end
end
