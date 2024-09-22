module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :name, String, null: true
    field :bio, String, null: true
    field :profile_image_url, String, null: true

    def profile_image_url
      object.profile_image.service_url if object.profile_image.attached?
    end

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
