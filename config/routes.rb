# frozen_string_literal: true

PhcdevworksAccountsStytch::Engine.routes.draw do
  namespace :b2b do
    post 'magic_links/authenticate', to: 'magic_links#authenticate'
    post 'magic_links/invite', to: 'magic_links#invite'
    post 'magic_links/login_or_signup', to: 'magic_links#login_or_signup'
  end

  namespace :b2c do
    post 'magic_links/authenticate', to: 'magic_links#authenticate'
    post 'magic_links/invite', to: 'magic_links#invite'
    post 'magic_links/login_or_create', to: 'magic_links#login_or_create'
    post 'magic_links/revoke_invite', to: 'magic_links#revoke_invite'
    post 'magic_links/send', to: 'magic_links#send_magic_link'
  end
end
