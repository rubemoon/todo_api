Rails.application.routes.draw do
  # devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }, defaults: { format: :json }
  # get "up" => "rails/health#show", as: :rails_health_check

  # resources :todos, only: [ :index, :show, :create, :update, :destroy ]

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"
end
