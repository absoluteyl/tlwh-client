Rails.application.routes.draw do
  get    "users",     to: "users#index"
  get    "signup",    to: "users#new"
  post   "signup",    to: "users#create"
end
