# frozen_string_literal: true

namespace :b2c do
  # B2C Authentication Routes for both Passwords and Magic Links
  get 'authenticate',
      to: 'authenticate#authenticate', as: 'authenticate'
  match 'process_authenticate',
        to: 'authenticate#process_authenticate', via: %i[get post], as: 'process_authenticate'
end
