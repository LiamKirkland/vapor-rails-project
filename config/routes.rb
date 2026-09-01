Rails.application.routes.draw do
  resources :games, only: %i[new index show create] do
    resources :user_games, only: %i[create]
  end
  resources :user_games, only: %i[destroy]
  resources :users, only: %i[show index]
  resources :friendships, only: %i[create destroy] do
    member do
      patch :accept
    end
  end

  get "/login" => "sessions#new"
  post "/login" => "sessions#create"
  post "/logout" => "sessions#destroy"
  get "/signup" => "users#new"
  post "/signup" => "users#create"

  root "users#home"
end
