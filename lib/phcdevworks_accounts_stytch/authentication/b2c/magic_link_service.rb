# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    module B2C
      class MagicLinkService
        def initialize
          @client = PhcdevworksAccountsStytch::StytchClient.b2c_client
        end

        def login_or_create(email)
          @client.magic_links.email.login_or_create(email: email)
        rescue Stytch::Error => e
          handle_error(e)
        end

        def send_magic_link(email)
          @client.magic_links.email.send(email: email)
        rescue Stytch::Error => e
          handle_error(e)
        end

        def invite(email)
          @client.magic_links.email.invite(email: email)
        rescue Stytch::Error => e
          handle_error(e)
        end

        def revoke_invite(email)
          @client.magic_links.email.revoke_invite(email: email)
        rescue Stytch::Error => e
          handle_error(e)
        end

        def authenticate(token)
          @client.magic_links.authenticate(token: token)
        rescue Stytch::Error => e
          handle_error(e)
        end

        private

        def handle_error(error)
          Rails.logger.error "Stytch B2C Magic Link error: #{error.message}"
          nil
        end
      end
    end
  end
end
