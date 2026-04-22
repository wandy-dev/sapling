Rails.application.routes.draw do
  devise_for :users
  root "landing#index"

  resources :posts do
    resources :replies
  end

  resources :communities, only: [:index, :show, :new, :create] do
    resources :memberships, only: [:index, :create]
  end

  resources :accounts, path: :profiles, as: :profiles, controller: :profiles
  resources :accounts

  resources :favorites, only: [:create, :show]

  get "up" => "rails/health#show", as: :rails_health_check
end
