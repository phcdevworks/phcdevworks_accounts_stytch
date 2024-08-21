# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    module B2c
      class MagicLinkService
        def initialize
          @client = PhcdevworksAccountsStytch::StytchClient.b2c_client
        end

        def login_or_create(email)
          response = @client.magic_links.email.login_or_create(email: email)
          handle_response(response)
        end

        def send_magic_link(email)
          response = @client.magic_links.email.send(email: email)
          handle_response(response)
        end

        def invite(email, _session_token = nil)
          response = @client.magic_links.email.invite(email: email)
          handle_response(response)
        end

        def revoke_invite(email)
          response = @client.magic_links.email.revoke_invite(email: email)
          handle_response(response)
        end

        def authenticate(token)
          response = @client.magic_links.authenticate(token: token)
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
