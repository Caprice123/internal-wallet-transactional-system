Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      post "/login", to: "sessions#login"
      delete "/logout", to: "sessions#logout"

      namespace :transactions do
        resources :wallets, only: %i[] do
          collection do
            post "/deposit", to: "wallets#deposit"
            post "/withdraw", to: "wallets#withdraw"
            post "/transfer", to: "wallets#transfer"
          end
        end
      end
    end
  end
end
