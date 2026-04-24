Rails.application.routes.draw do
  devise_for :users
  root "landing#index"

  constraints subdomain: 'api' do
    namespace :api do
      namespace :v1 do
        resources :communities do
          get :check_subdomain
        end
      end
    end
  end

  resources :posts do
    resources :replies
  end

  resources :communities, only: [:index, :show, :new, :create], path: :branches do
    resources :memberships, only: [:index, :create]
  end

  resources :accounts, path: :profiles, as: :profiles, controller: :profiles
  resources :accounts

  resources :favorites, only: [:create, :show]

  get "up" => "rails/health#show", as: :rails_health_check
end
