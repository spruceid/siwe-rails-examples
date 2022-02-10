# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sessions#index'

  match '/auth/:provider/callback', to: 'sessions#create', via: %i[get post]
  get '/auth/failure', to: 'sessions#failure'
end
