Rails.application.routes.draw do
  root 'users#index'

  resources :users, except: [:new, :create, :destroy]
  get    "signup",    to: "users#new"
  post   "signup",    to: "users#create"

  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  namespace :api do
    namespace :v1 do
      resources :users, only: :show do
        member do
          post "mint", to: "users#mint"
        end
      end
    end
  end
end
