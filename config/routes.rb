require 'sidekiq/web'
require 'rack/session/cookie'

Sidekiq::Web.use Rack::Session::Cookie, secret: Rails.application.credentials.secret_key_base || 'some_secret_key_base'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == ENV["ADMIN_USER"] && password == ENV["ADMIN_PASSWORD"]
end

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

  # Handle Chrome DevTools request to reduce log noise
  get "/.well-known/appspecific/com.chrome.devtools.json" => proc { [ 204, {}, [] ] }

  # Defines the root path route ("/")
  # root "posts#index"
  #  devise_for :users,
  namespace :api do
    namespace :v1 do
      # Health check endpoints
      get 'health/sidekiq', to: 'health#sidekiq_status'
      get 'health/system', to: 'health#system_status'
      
      resources :tracked_keywords, only: [ :index, :create, :destroy ] do
        member do
          post :fetch_mentions
          get :mentions
          get :relevant_mentions
          get :status
        end
      end
    end
  end

  mount Sidekiq::Web => '/sidekiq'
  mount ActionCable.server => '/cable'
end
