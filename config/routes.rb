# frozen_string_literal: true

PhcdevworksAccountsStytch::Engine.routes.draw do
  namespace :b2b do
    # GET routes for displaying forms or views
    get 'magic_links/invite', to: 'magic_links#invite'
    get 'magic_links/authenticate', to: 'magic_links#authenticate'
    get 'magic_links/login', to: 'magic_links#login_or_signup'
    get 'magic_links/signup', to: 'magic_links#login_or_signup'

    # POST routes for processing form submissions or API requests
    post 'magic_links/process_authenticate', to: 'magic_links#process_authenticate'
    post 'magic_links/process_invite', to: 'magic_links#process_invite'
    post 'magic_links/process_login_or_signup', to: 'magic_links#process_login_or_signup'
  end

  namespace :b2c do
    # GET routes for displaying forms or views
    get 'magic_links/invite', to: 'magic_links#invite'
    get 'magic_links/revoke_invite', to: 'magic_links#invite'
    get 'magic_links/authenticate', to: 'magic_links#authenticate'
    get 'magic_links/login', to: 'magic_links#login_or_signup'
    get 'magic_links/signup', to: 'magic_links#login_or_signup'

    # POST routes for processing form submissions or API requests
    post 'magic_links/invite', to: 'magic_links#invite'
    post 'magic_links/authenticate', to: 'magic_links#authenticate'
    post 'magic_links/login_or_create', to: 'magic_links#login_or_create'
    post 'magic_links/revoke_invite', to: 'magic_links#revoke_invite'
    post 'magic_links/send', to: 'magic_links#send_magic_link'
  end
end
