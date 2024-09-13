# frozen_string_literal: true

namespace :b2c do
  # PHCDEVWORKS - B2C Routes for Magic Links
  get 'magic_links/invite', to: 'magic_links#invite', as: 'magic_links_invite'
  get 'magic_links/login', to: 'magic_links#login_or_signup', as: 'magic_links_login'
  get 'magic_links/signup', to: 'magic_links#login_or_signup', as: 'magic_links_signup'

  post 'magic_links/process_invite', to: 'magic_links#process_invite', as: 'magic_links_process_invite'
  post 'magic_links/process_revoke_invite', to: 'magic_links#process_revoke_invite', as: 'magic_links_process_revoke_invite'
  post 'magic_links/process_login_or_signup', to: 'magic_links#process_login_or_signup', as: 'magic_links_process_login_or_signup'

  # PHCDEVWORKS - B2C Routes for Passwords
  get 'passwords/reset', to: 'passwords#reset_password', as: 'password_reset'
  get 'passwords/reset/existing', to: 'passwords#reset_existing_password', as: 'password_reset_existing'
  get 'passwords/reset/session', to: 'passwords#reset_with_session', as: 'password_reset_session'
  get 'passwords/reset/start', to: 'passwords#reset_start', as: 'password_reset_start'

  post 'passwords/reset', to: 'passwords#process_reset_password', as: 'process_password_reset'
  post 'passwords/reset/existing', to: 'passwords#process_reset_existing_password', as: 'process_reset_existing_password'
  post 'passwords/reset/session', to: 'passwords#process_reset_with_session', as: 'process_reset_session'
  post 'passwords/reset/start', to: 'passwords#process_reset_start', as: 'process_reset_start'

  # PHCDEVWORKS - B2C Authentication Routes for both Passwords and Magic Links
  get 'authenticate', to: 'authenticate#authenticate', as: 'authenticate'
  match 'process_authenticate', to: 'authenticate#process_authenticate', via: %i[get post], as: 'process_authenticate'
end
