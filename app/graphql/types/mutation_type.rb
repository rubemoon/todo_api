# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :sign_in_user, mutation: Mutations::SignInUser
    field :sign_up_user, mutation: Mutations::SignUpUser
    field :create_todo, mutation: Mutations::CreateTodo
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
