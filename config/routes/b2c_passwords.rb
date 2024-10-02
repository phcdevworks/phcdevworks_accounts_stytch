# frozen_string_literal: true

namespace :b2c do
  # B2C Routes for Passwords
  get 'passwords/reset',
      to: 'passwords#reset_password', as: 'password_reset'
  get 'passwords/reset/existing',
      to: 'passwords#reset_existing_password', as: 'password_reset_existing'
  get 'passwords/reset/session',
      to: 'passwords#reset_with_session', as: 'password_reset_session'
  get 'passwords/reset/start',
      to: 'passwords#reset_start', as: 'password_reset_start'

  post 'passwords/reset',
       to: 'passwords#process_reset_password', as: 'process_password_reset'
  post 'passwords/reset/existing',
       to: 'passwords#process_reset_existing_password', as: 'process_reset_existing_password'
  post 'passwords/reset/session',
       to: 'passwords#process_reset_with_session', as: 'process_reset_session'
  post 'passwords/reset/start',
       to: 'passwords#process_reset_start', as: 'process_reset_start'
end
