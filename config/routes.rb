Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      registrations: "users/registrations",
      sessions: "users/sessions",
      passwords: 'users/passwords',
      confirmations: 'users/confirmations'
    },
    path: "",
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      registration: "signup",
      password: "reset-password",
      confirmation: "verify-email"
    }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  #  devise_for :users,
  namespace :api do
    namespace :v1 do
      resources :tracked_keywords, only: [ :index, :create, :destroy ]
    end
  end
end
