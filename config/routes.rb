Rails.application.routes.draw do
  root 'users#show'

  get    "users",     to: "users#index"
  get    "users/:id", to: "users#show"
  get    "signup",    to: "users#new"
  post   "signup",    to: "users#create"

  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  namespace :api do
    namespace :v1 do
      resources :users, only: :show
    end
  end
end
