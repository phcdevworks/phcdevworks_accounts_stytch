# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    module B2c
      class PasswordService
        def initialize
          @client = PhcdevworksAccountsStytch::Stytch::Client.b2c_client
        end

        def reset_start(email)
          log_action('Password Reset Start', email: email)
          response = @client.passwords.email.reset_start(
            email: email
          )
          handle_response(response)
        end

        def reset(password_reset_token, new_password)
          log_action('Password Reset', token: password_reset_token)
          response = @client.passwords.email.reset(
            token: password_reset_token,
            password: new_password
          )
          handle_response(response)
        end

        def reset_existing(email, old_password, new_password)
          log_action('Existing Password Reset', email: email)
          response = @client.passwords.existing_password.reset(
            email: email,
            existing_password: old_password,
            new_password: new_password
          )
          handle_response(response)
        end

        def reset_with_session(session_token, new_password)
          log_action('Session-based Password Reset', session_token: session_token)
          response = @client.passwords.sessions.reset(
            session_token: session_token,
            password: new_password
          )
          handle_response(response)
        end

        def authenticate_password(email, password)
          log_action('Password Authentication', email: email)
          response = @client.passwords.authenticate(
            email: email,
            password: password
          )
          handle_response(response)
        end

        private

        def handle_response(response)
          PhcdevworksAccountsStytch::Stytch::Response.handle_response(response)
        rescue PhcdevworksAccountsStytch::Stytch::Error => e
          log_error(e)
          raise
        end

        def log_action(action_name, details = {})
          Rails.logger.info "Starting #{action_name} with details: #{details.inspect}"
        end

        def log_error(error)
          Rails.logger.error "Error occurred: #{error.message}"
          Rails.logger.error error.backtrace.join("\n")
        end
      end
    end
  end
end
