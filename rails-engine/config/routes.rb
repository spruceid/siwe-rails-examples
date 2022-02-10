require 'siwe_rails'

Rails.application.routes.draw do
  root 'sessions#index'

  get 'profile' => 'sessions#profile', :as => 'profile'
  post 'sign-in' => 'sessions#sign_in', :as => 'sign-in'
  post 'sign-out' => 'sessions#sign_out', :as => 'sign-out'

  mount SiweRails::Engine => '/'

  resources :users
  resources :sessions
end
