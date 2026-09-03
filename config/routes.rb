Rails.application.routes.draw do
  resources :games, only: %i[new index show create edit update] do
    resources :user_games, only: %i[create update]
  end
  resources :user_games, only: %i[destroy]
  resources :users, only: %i[show index] do
    resources :user_games, only: %i[index]
    member do
      get :admin_edit
      patch :admin_update
    end
  end
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
  get "/edit_profile" => "users#edit"
  patch "/edit_profile" => "users#update"

  root "users#home"
end
