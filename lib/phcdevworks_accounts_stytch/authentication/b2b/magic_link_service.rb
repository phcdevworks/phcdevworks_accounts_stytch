# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    module B2b
      class MagicLinkService
        def initialize
          @client = PhcdevworksAccountsStytch::Stytch::Client.b2b_client
        end

        # Process the login or signup
        def process_login_or_signup(email, organization_id)
          log_action('Login or Signup', email: email, organization_id: organization_id)
          response = @client.magic_links.email.login_or_signup(
            organization_id: organization_id,
            email_address: email
          )
          handle_response(response, 'User logged in or signed up successfully')
        end

        # Process the invite
        def process_revoke_invite(email, organization_id)
          log_action('Revoke Invite', email: email, organization_id: organization_id)
          response = @client.magic_links.revoke(email: email, organization_id: organization_id)
          handle_response(response, 'Invite revoked successfully')
        rescue SomeStytchSpecificError => e
          # Map the error code to a not-found status
          raise PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: e.error_code == 'invite_not_found' ? 404 : 400,
            error_code: e.error_code,
            error_message: e.error_message
          )
        end

        private

        # Handle the response
        def handle_response(response, success_message)
          PhcdevworksAccountsStytch::Stytch::Response.handle_response(response).tap do |result|
            Rails.logger.info(success_message)
          end
        rescue PhcdevworksAccountsStytch::Stytch::Error => e
          handle_stytch_error(e)
        end

        # Build the method options
        def build_method_options(session_token)
          PhcdevworksAccountsStytch::Stytch::MethodOptions.new(
            authorization: { session_token: session_token }
          )
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
