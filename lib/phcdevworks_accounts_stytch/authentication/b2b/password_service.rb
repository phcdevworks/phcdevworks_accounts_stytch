# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    module B2b
      class PasswordService
        def authenticate_password(email, password, organization_id)
          client = PhcdevworksAccountsStytch::Stytch::Client.b2b_client
          response = client.passwords.authenticate(
            email_address: email,
            password: password,
            organization_id: organization_id
          )

          PhcdevworksAccountsStytch::Stytch::Response.handle_response(response)
        rescue Stytch::Error => e
          raise PhcdevworksAccountsStytch::Stytch::Error.new(error_message: e.message)
        end
      end
    end
  end
end
