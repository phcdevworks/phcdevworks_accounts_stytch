# frozen_string_literal: true

PhcdevworksAccountsStytch::Engine.routes.draw do
  post 'login', to: 'authentication/login#create'
  get 'authenticate', to: 'authentication/processor#create'
end
