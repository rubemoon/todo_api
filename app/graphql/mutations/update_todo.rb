module Mutations
  class UpdateTodo < BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false
    argument :due_date, GraphQL::Types::ISO8601DateTime, required: false
    argument :completed, Boolean, required: false

    field :todo, Types::TodoType, null: true
    field :errors, [ String ], null: false

    def resolve(id:, title: nil, description: nil, due_date: nil, completed: nil)
      user = context[:current_user]
      return { todo: nil, errors: [ "User not signed in" ] } unless user

      todo = user.todos.find_by(id: id)
      return { todo: nil, errors: [ "Todo not found" ] } unless todo

      if todo.update(title: title, description: description, due_date: due_date, completed: completed)
        { todo: todo, errors: [] }
      else
        { todo: nil, errors: todo.errors.full_messages }
      end
    end
  end
end
