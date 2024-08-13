# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    module B2b
      class MagicLinkService
        def initialize
          @client = PhcdevworksAccountsStytch::StytchClient.b2b_client
        end

        def invite(email, organization_id)
          @client.magic_links.email.invite(
            organization_id: organization_id,
            email_address: email
          )
        rescue Stytch::Error => e
          handle_error(e)
        end

        def authenticate(token)
          @client.magic_links.authenticate(magic_links_token: token)
        rescue Stytch::Error => e
          handle_error(e)
        end

        private

        def handle_error(error)
          Rails.logger.error "Stytch B2B Magic Link error: #{error.message}"
          nil
        end
      end
    end
  end
end
