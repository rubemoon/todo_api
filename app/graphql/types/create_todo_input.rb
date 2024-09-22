module Types
  class CreateTodoInput < Types::BaseInputObject
    argument :title, String, required: true
    argument :description, String, required: false
    argument :due_date, GraphQL::Types::ISO8601DateTime, required: false
    argument :completed, Boolean, required: false
  end
end
