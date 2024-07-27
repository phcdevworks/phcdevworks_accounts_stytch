# frozen_string_literal: true

PhcdevworksAccountsStytch::Engine.routes.draw do
  namespace :authentication do
    get 'auth/google', to: 'sessions#google_login', as: 'google_login'
    get 'auth/google/callback', to: 'sessions#google_callback', as: 'google_callback'
  end
end
