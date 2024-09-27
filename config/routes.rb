Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :session, only: %i[] do
        collection do
          post "/login", to: "sessions#login"
          post "/logout", to: "sessions#logout"
        end
      end
    end
  end
end
