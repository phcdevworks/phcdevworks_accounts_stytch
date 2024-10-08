# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    module B2b
      class PasswordService
        # Initialize the client
        def initialize
          @client = PhcdevworksAccountsStytch::Stytch::Client.b2b_client
        end

        # Process the password reset start
        def reset_start(email, organization_id)
          log_action('Password Reset Start', email: email, organization_id: organization_id)
          response = @client.passwords.email.reset_start(
            organization_id: organization_id,
            email_address: email
          )
          handle_response(response)
        end

        # Process the password reset
        def reset(password_reset_token, new_password)
          log_action('Password Reset', token: password_reset_token)
          response = @client.passwords.email.reset(
            password_reset_token: password_reset_token,
            password: new_password
          )
          handle_response(response)
        end

        # Process the existing password reset
        def reset_existing(email, old_password, new_password, organization_id)
          log_action('Existing Password Reset', email: email, organization_id: organization_id)
          response = @client.passwords.existing_password.reset(
            email_address: email,
            existing_password: old_password,
            new_password: new_password,
            organization_id: organization_id
          )
          handle_response(response)
        end

        # Process the session-based password reset
        def reset_with_session(session_token, new_password, organization_id)
          log_action('Session-based Password Reset', session_token: session_token, organization_id: organization_id)
          response = @client.passwords.sessions.reset(
            session_token: session_token,
            password: new_password,
            organization_id: organization_id
          )
          handle_response(response)
        end

        # Process the password authentication
        def authenticate_password(email, password, organization_id)
          log_action('Password Authentication', email: email, organization_id: organization_id)
          response = @client.passwords.authenticate(
            email_address: email,
            password: password,
            organization_id: organization_id
          )
          handle_response(response)
        end

        private

        # Handle the response
        def handle_response(response)
          PhcdevworksAccountsStytch::Stytch::Response.handle_response(response)
        rescue PhcdevworksAccountsStytch::Stytch::Error => e
          log_error(e)
          raise
        end

        # Log the action
        def log_action(action_name, details = {})
          Rails.logger.info "Starting #{action_name} with details: #{details.inspect}"
        end

        # Log the error
        def log_error(error)
          Rails.logger.error "Error occurred: #{error.message}"
          Rails.logger.error error.backtrace.join("\n")
        end
      end
    end
  end
end
