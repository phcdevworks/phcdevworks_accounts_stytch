# frozen_string_literal: true

PhcdevworksAccountsStytch::Engine.routes.draw do
  post 'login', to: 'authentication#login'
  get 'authenticate', to: 'authentication#authenticate'
end
