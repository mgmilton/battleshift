Rails.application.routes.draw do
  root "welcome#index"
  get "/register", to: "register#new"
  post "/register", to: "register#create"
  get '/dashboard', to: "dashboard#index"
  namespace :api do
    namespace :v1 do
      resources :games, only: [:show] do
        post "/shots", to: "games/shots#create"
      end
    end
  end
end
