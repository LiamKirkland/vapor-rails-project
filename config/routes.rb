Rails.application.routes.draw do
  # resources :users
  get "/login" => "sessions#new"
  post "/login" => "sessions#create"
  post "/logout" => "sessions#destroy"
  get "/signup" => "users#new"
  post "/signup" => "users#create"

  root "users#show"
end
