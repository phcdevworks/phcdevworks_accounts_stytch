# frozen_string_literal: true

namespace :b2b do
  # PHCDEVWORKS - B2B Routes for Magic Links
  get 'magic_links/invite/:organization_slug', to: 'magic_links#invite', as: 'magic_links_invite'
  get 'magic_links/login/:organization_slug', to: 'magic_links#login_or_signup', as: 'magic_links_login'
  get 'magic_links/signup/:organization_slug', to: 'magic_links#login_or_signup', as: 'magic_links_signup'

  post 'magic_links/process_invite/:organization_slug', to: 'magic_links#process_invite', as: 'magic_links_process_invite'
  post 'magic_links/process_login_or_signup/:organization_slug', to: 'magic_links#process_login_or_signup',
                                                                 as: 'magic_links_process_login_or_signup'

  # PHCDEVWORKS - B2B Routes for Passwords
  get 'passwords/reset/start', to: 'passwords#reset_start_form', as: 'password_reset_start_form'
  post 'passwords/reset/start', to: 'passwords#reset_start', as: 'password_reset_start'

  get 'passwords/reset', to: 'passwords#reset_form', as: 'password_reset_form'
  post 'passwords/reset', to: 'passwords#reset_process', as: 'password_reset_process'

  get 'passwords/reset/existing', to: 'passwords#reset_existing_password_form', as: 'password_reset_existing_form'
  post 'passwords/reset/existing', to: 'passwords#reset_existing_password', as: 'password_reset_existing'

  get 'passwords/reset/session', to: 'passwords#reset_with_session_form', as: 'password_reset_session_form'
  post 'passwords/reset/session', to: 'passwords#reset_with_session', as: 'password_reset_session'

  # PHCDEVWORKS - B2B Authentication Routes for both Passwords and Magic Links
  get 'authenticate', to: 'authenticate#authenticate', as: 'authenticate'
  match 'process_authenticate', to: 'authenticate#process_authenticate', via: %i[get post], as: 'process_authenticate'
end
