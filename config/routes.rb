Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :session, only: %i[] do
    collection do
      post "/login", to: "sessions#login"
    end
  end
end
