# frozen_string_literal: true

namespace :b2c do
  # B2C Routes for Magic Links
  get 'magic_links/invite',
      to: 'magic_links#invite', as: 'magic_links_invite'
  get 'magic_links/login',
      to: 'magic_links#login_or_signup', as: 'magic_links_login'
  get 'magic_links/signup',
      to: 'magic_links#login_or_signup', as: 'magic_links_signup'

  post 'magic_links/process_invite',
       to: 'magic_links#process_invite', as: 'magic_links_process_invite'
  post 'magic_links/process_revoke_invite',
       to: 'magic_links#process_revoke_invite', as: 'magic_links_process_revoke_invite'
  post 'magic_links/process_login_or_signup',
       to: 'magic_links#process_login_or_signup', as: 'magic_links_process_login_or_signup'
end
