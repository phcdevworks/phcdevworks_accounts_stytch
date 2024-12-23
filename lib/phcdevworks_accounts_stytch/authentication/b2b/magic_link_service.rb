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
        rescue PhcdevworksAccountsStytch::Stytch::Error => e
          raise e
        rescue StandardError => e
          raise handle_unexpected_error(e)
        end

        # Process the revoke invite
        def process_revoke_invite(email, organization_id)
          validate_revoke_invite_params!(email, organization_id)

          response = @client.magic_links.email.revoke_invite(
            email_address: email,
            organization_id: organization_id
          )
          handle_response(response, 'Invite successfully revoked')
        rescue PhcdevworksAccountsStytch::Stytch::Error => e
          raise e
        rescue StandardError => e
          raise handle_unexpected_error(e)
        end

        private

        def validate_revoke_invite_params!(email, organization_id)
          raise ArgumentError, 'Email is required' if email.blank?
          raise ArgumentError, 'Organization ID is required' if organization_id.blank?
        end

        def handle_response(response, success_message)
          unless response[:status_code] == 200
            raise PhcdevworksAccountsStytch::Stytch::Error.new(
              status_code: response[:status_code],
              error_code: response[:error_code] || 'unknown_error',
              error_message: response[:error_message] || 'An unknown error occurred'
            )
          end

          Rails.logger.info(success_message)
          response
        end

        def log_action(action_name, details = {})
          Rails.logger.info "Starting #{action_name} with details: #{details.inspect}"
        end

        def handle_unexpected_error(error)
          Rails.logger.error "Unexpected Error: #{error.message} - Backtrace: #{error.backtrace.take(5).join("\n")}"
          PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: 500,
            error_message: 'An unexpected error occurred',
            original_error: error
          )
        end
      end
    end
  end
end
