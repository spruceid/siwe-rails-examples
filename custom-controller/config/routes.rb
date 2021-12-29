Rails.application.routes.draw do
  root 'sessions#index'

  get 'profile' => 'sessions#profile', :as => 'profile'

  post 'sign-in' => 'sessions#sign_in', :as => 'sign-in'
  post 'message' => 'sessions#message', :as => 'message'
  post 'sign-out' => 'sessions#sign_out', :as => 'sign-out'

  resources :users
  resources :sessions
end
