# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    class PasswordService
      def initialize(client)
        @client = client
      end

      def authenticate(email, password)
        @client.passwords.authenticate(
          email: email,
          password: password
        )
      rescue Stytch::Error => e
        handle_error(e)
      end

      private

      def handle_error(error)
        Rails.logger.error "Stytch Password error: #{error.message}"
        nil
      end
    end
  end
end
