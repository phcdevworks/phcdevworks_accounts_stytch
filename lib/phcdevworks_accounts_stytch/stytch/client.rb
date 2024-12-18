# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    class Client
      class << self
        # Initializes and retrieves the B2B client, using memoization.
        def b2b_client
          @b2b_client ||= create_client(:b2b, StytchB2B::Client)
        end

        # Initializes and retrieves the B2C client, using memoization.
        def b2c_client
          @b2c_client ||= create_client(:b2c, ::Stytch::Client)
        end

        private

        # Creates a client for the given type using the provided client class.
        def create_client(type, client_class)
          credentials = fetch_credentials(type)
          raise_missing_credentials_error(type) unless credentials

          client_class.new(
            project_id: credentials[:project_id],
            secret: credentials[:secret]
          )
        end

        # Fetches credentials for the specified client type.
        def fetch_credentials(type)
          {
            project_id: Rails.application.credentials.dig(:stytch, type, :project_id),
            secret: Rails.application.credentials.dig(:stytch, type, :secret)
          }.compact.presence
        end

        # Raises an error if credentials are missing for the specified client type.
        def raise_missing_credentials_error(type)
          raise PhcdevworksAccountsStytch::Stytch::Error.new(
            error_message: "Stytch #{type.to_s.upcase} credentials are missing"
          )
        end
      end
    end
  end
end
