# frozen_string_literal: true

Rails.application.routes.draw do
  # Admin panel
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Defines the root path route ("/")
  root 'articles#index'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # User accounts
  devise_for :user

  # User profiles
  resources :users, only: %i[index show]

  # Articles, comments and likes for them
  resources :articles do
    resources :comments, only: %i[index create destroy] do
      resources :likes, only: %i[create destroy]
    end

    resources :likes, only: %i[create destroy]
  end

  # --- API --- #
  namespace :api do
    namespace :v1 do
      resources :articles, only: %i[index show]
    end
  end
end
