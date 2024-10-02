# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    module B2b
      class MagicLinkService
        # Initialize the client
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
          handle_response(response)
        end

        # Process the invite
        def process_invite(email, organization_id, session_token)
          log_action('Invite', email: email, organization_id: organization_id)
          options = build_method_options(session_token)
          response = @client.magic_links.email.invite(
            organization_id: organization_id,
            email_address: email,
            method_options: options
          )
          handle_response(response)
        end

        # Process the authenticate
        def process_authenticate(magic_links_token)
          log_action('Authenticate', magic_links_token: magic_links_token)
          response = @client.magic_links.authenticate(magic_links_token: magic_links_token)
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

        # Log the error
        def log_error(error)
          Rails.logger.error "Error occurred: #{error.message}"
          Rails.logger.error error.backtrace.join("\n")
        end
      end
    end
  end
end
