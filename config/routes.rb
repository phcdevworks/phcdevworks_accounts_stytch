# frozen_string_literal: true

PhcdevworksAccountsStytch::Engine.routes.draw do
  namespace :authentication do
    post 'login', to: 'login#create'
    post 'process', to: 'processor#create'
  end
end
