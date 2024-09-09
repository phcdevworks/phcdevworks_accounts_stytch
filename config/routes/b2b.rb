# frozen_string_literal: true

namespace :b2b do
  # MagicLinksController routes
  get 'magic_links/invite/:organization_slug', to: 'magic_links#invite', as: 'magic_links_invite'
  get 'magic_links/login/:organization_slug', to: 'magic_links#login_or_signup', as: 'magic_links_login'
  get 'magic_links/signup/:organization_slug', to: 'magic_links#login_or_signup', as: 'magic_links_signup'

  post 'magic_links/process_invite/:organization_slug', to: 'magic_links#process_invite', as: 'magic_links_process_invite'
  post 'magic_links/process_login_or_signup/:organization_slug', to: 'magic_links#process_login_or_signup',
                                                                 as: 'magic_links_process_login_or_signup'

  # PasswordsController routes
  get 'passwords/reset/start', to: 'passwords#reset_start_form', as: 'b2b_password_reset_start_form'
  post 'passwords/reset/start', to: 'passwords#reset_start', as: 'b2b_password_reset_start'

  get 'passwords/reset', to: 'passwords#reset_form', as: 'b2b_password_reset_form'
  post 'passwords/reset', to: 'passwords#reset_process', as: 'b2b_password_reset_process'

  get 'passwords/reset/existing', to: 'passwords#reset_existing_password_form', as: 'b2b_password_reset_existing_form'
  post 'passwords/reset/existing', to: 'passwords#reset_existing_password', as: 'b2b_password_reset_existing'

  get 'passwords/reset/session', to: 'passwords#reset_with_session_form', as: 'b2b_password_reset_session_form'
  post 'passwords/reset/session', to: 'passwords#reset_with_session', as: 'b2b_password_reset_session'

  # AuthenticateController route
  get 'authenticate', to: 'authenticate#authenticate', as: 'authenticate'
  post 'process_authenticate', to: 'authenticate#process_authenticate', as: 'process_authenticate'
end
