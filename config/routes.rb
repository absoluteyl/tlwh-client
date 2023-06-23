Rails.application.routes.draw do
  get    "users",     to: "users#index"
  get    "signup",    to: "users#new"
  post   "signup",    to: "users#create"

  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  get    "logout", to: "sessions#destroy"
  delete "logout", to: "sessions#destroy"
  post   "logout", to: "sessions#destroy"
end
