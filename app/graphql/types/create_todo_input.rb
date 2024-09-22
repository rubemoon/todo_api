module Types
  class CreateTodoInput < Types::BaseInputObject
    argument :title, String, required: true
    argument :description, String, required: false
  end
end
