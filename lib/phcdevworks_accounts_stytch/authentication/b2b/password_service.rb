# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    module B2b
      class PasswordService
        def initialize
          @client = PhcdevworksAccountsStytch::Stytch::Client.b2b_client
        end

        def reset_start(email, organization_id)
          log_action('Password Reset Start', email: email, organization_id: organization_id)
          response = @client.passwords.email.reset_start(
            organization_id: organization_id,
            email_address: email
          )
          handle_response(response)
        end

        def reset(password_reset_token, new_password)
          log_action('Password Reset', password_reset_token: password_reset_token)
          response = @client.passwords.email.reset(
            password_reset_token: password_reset_token,
            password: new_password
          )
          handle_response(response)
        end

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

        def reset_with_session(session_token, new_password, organization_id)
          log_action('Session-based Password Reset', session_token: session_token, organization_id: organization_id)
          response = @client.passwords.sessions.reset(
            session_token: session_token,
            password: new_password,
            organization_id: organization_id
          )
          handle_response(response)
        end

        def process_authenticate(magic_links_token)
          log_action('Authenticate', magic_links_token: magic_links_token)
          response = @client.magic_links.authenticate(magic_links_token: magic_links_token)
          handle_response(response)
        end

        private

        def handle_response(response)
          PhcdevworksAccountsStytch::Stytch::Response.handle_response(response)
        rescue PhcdevworksAccountsStytch::Stytch::Error => e
          log_error(e)
          raise
        end

        def build_method_options(session_token)
          PhcdevworksAccountsStytch::Stytch::MethodOptions.new(
            authorization: { session_token: session_token }
          )
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
