# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    module B2c
      class PasswordService
        def authenticate_password(email, password)
          client = PhcdevworksAccountsStytch::Stytch::Client.b2c_client
          response = client.passwords.authenticate(
            email: email,
            password: password
          )

          PhcdevworksAccountsStytch::Stytch::Response.handle_response(response)
        rescue Stytch::Error => e
          raise PhcdevworksAccountsStytch::Stytch::Error.new(error_message: e.message)
        end
      end
    end
  end
end
