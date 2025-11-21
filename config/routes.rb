Rails.application.routes.draw do
  devise_for :users
  root "landing#index"

  resources :posts do
    resources :replies
  end

  constraints subdomain: /.*/ do
    resources :accounts, path: :profiles, as: :profiles, controller: :profiles
    resources :accounts

    resources :posts, path: :community, only: :index
    resources :posts, path: :following, only: :index

    resources :favorites, only: [:create, :show]
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "up" => "rails/health#show", as: :rails_health_check
end
