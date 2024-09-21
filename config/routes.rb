Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }
  post "/graphql", to: "graphql#execute"
  get "up" => "rails/health#show", as: :rails_health_check
end
