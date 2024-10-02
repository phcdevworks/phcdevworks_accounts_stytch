# frozen_string_literal: true

namespace :b2b do
  # B2B Routes for Passwords
  get 'passwords/reset/:organization_slug',
      to: 'passwords#reset_password', as: 'password_reset'
  get 'passwords/reset/existing/:organization_slug',
      to: 'passwords#reset_existing_password', as: 'password_reset_existing'
  get 'passwords/reset/session/:organization_slug',
      to: 'passwords#reset_with_session', as: 'password_reset_session'
  get 'passwords/reset/start/:organization_slug',
      to: 'passwords#reset_start', as: 'password_reset_start'

  post 'passwords/reset/:organization_slug', to: 'passwords#process_reset_password', as: 'process_password_reset'
  post 'passwords/reset/existing/:organization_slug',
       to: 'passwords#process_reset_existing_password', as: 'process_reset_existing_password'
  post 'passwords/reset/session/:organization_slug',
       to: 'passwords#process_reset_with_session', as: 'process_reset_session'

  post 'passwords/reset/start/:organization_slug',
       to: 'passwords#process_reset_start', as: 'process_reset_start'
end
