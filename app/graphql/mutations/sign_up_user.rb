module Mutations
  class SignUpUser < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true

    field :user, Types::UserType, null: false
    field :errors, [ String ], null: false

    def resolve(email:, password:, password_confirmation:)
      existing_user = User.find_by(email: email)
      if existing_user
        return { user: nil, errors: [ "User already exists with this email" ] }
      end

      user = User.new(email: email, password: password, password_confirmation: password_confirmation)
      if user.save
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end
