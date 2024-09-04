# frozen_string_literal: true

PhcdevworksAccountsStytch::Engine.routes.draw do
  namespace :b2b do
    # GET routes for displaying forms or views
    get 'magic_links/invite/:organization_slug', to: 'magic_links#invite', as: 'invite'
    get 'magic_links/authenticate/:organization_slug', to: 'magic_links#authenticate', as: 'authenticate'
    get 'magic_links/login/:organization_slug', to: 'magic_links#login_or_signup', as: 'login_or_signup'
    get 'magic_links/signup/:organization_slug', to: 'magic_links#login_or_signup', as: 'signup'

    # POST routes for processing form submissions or API requests
    post 'magic_links/process_authenticate/:organization_slug', to: 'magic_links#process_authenticate',
                                                                as: 'process_authenticate'
    post 'magic_links/process_invite/:organization_slug', to: 'magic_links#process_invite', as: 'process_invite'
    post 'magic_links/process_login_or_signup/:organization_slug', to: 'magic_links#process_login_or_signup',
                                                                   as: 'process_login_or_signup'
  end

  namespace :b2c do
    # GET routes for displaying forms or views
    get 'magic_links/invite', to: 'magic_links#invite'
    get 'magic_links/authenticate', to: 'magic_links#authenticate'
    get 'magic_links/login', to: 'magic_links#login_or_signup'
    get 'magic_links/signup', to: 'magic_links#login_or_signup'

    # POST routes for processing form submissions or API requests
    post 'magic_links/process_authenticate', to: 'magic_links#process_authenticate'
    post 'magic_links/process_invite', to: 'magic_links#process_invite'
    post 'magic_links/process_revoke_invite', to: 'magic_links#process_revoke_invite'
    post 'magic_links/process_login_or_signup', to: 'magic_links#process_login_or_signup'
  end
end
