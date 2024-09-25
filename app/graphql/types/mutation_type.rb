# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :sign_in_user, mutation: Mutations::SignInUser
    field :sign_up_user, mutation: Mutations::SignUpUser
    field :create_todo, mutation: Mutations::CreateTodo
    field :delete_todo, mutation: Mutations::DeleteTodo
    field :update_todo, mutation: Mutations::UpdateTodo
  end
end
