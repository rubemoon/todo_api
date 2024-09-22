module Mutations
  class CreateTodo < BaseMutation
    argument :title, String, required: true
    argument :description, String, required: false
    argument :due_date, GraphQL::Types::ISO8601DateTime, required: false
    argument :completed, Boolean, required: false

    field :todo, Types::TodoType, null: true
    field :errors, [ String ], null: false

    def resolve(title:, description: nil, due_date: nil, completed: false)
      user = context[:current_user]
      return { todo: nil, errors: [ "User not signed in" ] } unless user

      todo = user.todos.build(
        title: title,
        description: description,
        due_date: due_date,
        completed: completed
      )

      if todo.save
        { todo: todo, errors: [] }
      else
        Rails.logger.error("Todo creation failed: #{todo.errors.full_messages.join(', ')}")
        { todo: nil, errors: todo.errors.full_messages }
      end
    end
  end
end
