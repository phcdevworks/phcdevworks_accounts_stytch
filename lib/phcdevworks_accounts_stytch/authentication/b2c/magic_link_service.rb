# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    module B2c
      class MagicLinkService
        def initialize
          @client = PhcdevworksAccountsStytch::Stytch::Client.b2c_client
        end

        def process_login_or_signup(email)
          log_action('Login or Signup', email: email)
          response = @client.magic_links.email.login_or_create(email: email)
          handle_response(response)
        end

        def process_invite(email)
          log_action('Invite', email: email)
          response = @client.magic_links.email.invite(email: email)
          handle_response(response)
        end

        def process_revoke_invite(email)
          log_action('Revoke Invite', email: email)
          response = @client.magic_links.email.revoke_invite(email: email)
          handle_response(response)
        end

        def process_authenticate(token)
          log_action('Authenticate', magic_links_token: token)
          response = @client.magic_links.authenticate(token: token)
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
