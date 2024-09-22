module Mutations
  class SignInUser < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :errors, [ String ], null: false

    def resolve(email:, password:)
      user = User.find_by(email: email)

      if user&.valid_password?(password)
        # Ensure the user is authenticated and generate a JWT token
        token = JsonWebToken.encode(user_id: user.id)
        { token: token, errors: [] }
      else
        # Invalid credentials
        { token: nil, errors: [ "Invalid email or password" ] }
      end
    end
  end
end
