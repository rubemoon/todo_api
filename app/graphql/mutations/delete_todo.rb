module Mutations
  class DeleteTodo < BaseMutation
    argument :id, ID, required: true

    field :todo, Types::TodoType, null: true
    field :errors, [ String ], null: false

    def resolve(id:)
      user = context[:current_user]
      todo = user.todos.find_by(id: id)

      if todo
        todo.destroy
        {
          todo: todo,
          errors: []
        }
      else
        {
          todo: nil,
          errors: [ "Todo not found" ]
        }
      end
    end
  end
end
