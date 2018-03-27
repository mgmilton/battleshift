Rails.application.routes.draw do
  root "welcome#index"

  namespace :api do
    namespace :v1 do
      post "/games", to: "games#index"
      resources :games, only: [:show] do
        post "/shots", to: "games/shots#create"
        post "/ships", to: "games/ships#create"
      end
    end
  end

  get "/register", to: "register#new"
  post "/register", to: "register#create"
  get '/dashboard', to: "dashboard#index"
  get '/activate', to: "activation#index"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
end
