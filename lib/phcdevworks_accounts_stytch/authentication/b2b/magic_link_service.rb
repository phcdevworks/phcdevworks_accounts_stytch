# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    module B2b
      class MagicLinkService
        def initialize
          @client = PhcdevworksAccountsStytch::StytchClient.b2b_client
        end

        def process_login_or_signup(email, organization_id)
          response = @client.magic_links.email.login_or_signup(
            organization_id: organization_id,
            email_address: email
          )
          handle_response(response)
        end

        def process_invite(email, organization_id, session_token)
          options = PhcdevworksAccountsStytch::Stytch::MethodOptions.new(
            authorization: { session_token: session_token }
          )

          response = @client.magic_links.email.invite(
            organization_id: organization_id,
            email_address: email,
            method_options: options
          )
          handle_response(response)
        end

        def process_authenticate(magic_links_token)
          response = @client.magic_links.authenticate(magic_links_token: magic_links_token)
          handle_response(response)
        end

        private

        def handle_response(response)
          status_code = response[:status_code]

          if status_code && status_code >= 200 && status_code < 300
            response
          else
            raise PhcdevworksAccountsStytch::Stytch::Error.new(
              status_code: status_code,
              error_code: response[:error_code],
              error_message: response[:error_message] || 'An unknown error occurred'
            )
          end
        end
      end
    end
  end
end
