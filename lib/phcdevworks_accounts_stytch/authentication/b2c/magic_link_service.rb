# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    module B2c
      class MagicLinkService
        # Initialize the client
        def initialize
          @client = PhcdevworksAccountsStytch::Stytch::Client.b2c_client
        end

        # Process the login or signup
        def process_login_or_signup(email)
          log_action('Login or Signup', email: email)
          response = @client.magic_links.email.login_or_create(email: email)
          handle_response(response, 'User logged in or signed up successfully')
        end

        # Process the invite
        def process_invite(email)
          log_action('Invite', email: email)
          response = @client.magic_links.email.invite(email: email)
          handle_response(response, 'Invitation sent successfully')
        end

        # Process the revoke invite
        def process_revoke_invite(email)
          log_action('Revoke Invite', email: email)
          response = @client.magic_links.email.revoke_invite(email: email)
          handle_response(response, 'Invitation revoked successfully')
        end

        # Process the authenticate
        def process_authenticate(token)
          log_action('Authenticate', token: token)
          response = @client.magic_links.authenticate(token: token)
          handle_response(response, 'Magic Link authenticated successfully')
        end

        private

        # Handle the response
        def handle_response(response, success_message)
          PhcdevworksAccountsStytch::Stytch::Response.handle_response(response).tap do |_result|
            Rails.logger.info(success_message)
          end
        rescue PhcdevworksAccountsStytch::Stytch::Error => e
          handle_stytch_error(e)
        end

        # Log the action
        def log_action(action_name, details = {})
          Rails.logger.info "Starting #{action_name} with details: #{details.inspect}"
        end

        # Handle Stytch-specific errors
        def handle_stytch_error(error)
          Rails.logger.error "Stytch Error: #{error.message} (Code: #{error.error_code}, Status: #{error.status_code})"
          raise
        end
      end
    end
  end
end
