Rails.application.routes.draw do
  devise_for :users

  root "posts#index"

  resources :accounts, path: :profiles, as: :profiles
  resources :accounts

  resources :posts do
    resources :replies
  end

  resources :favorites, only: [:create, :show]

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "up" => "rails/health#show", as: :rails_health_check
end
