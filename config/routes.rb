# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'pages#homepage'

  resources :posts, only: %i[show]

  namespace :api do
    namespace :v1 do
      jsonapi_resources :posts, only: %i[index show]
    end
  end
end
