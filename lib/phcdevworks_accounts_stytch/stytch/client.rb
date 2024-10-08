# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    class Client
      class << self
        # Create the B2B client
        def b2b_client
          @b2b_client ||= create_b2b_client
        end

        # Create the B2C client
        def b2c_client
          @b2c_client ||= create_b2c_client
        end

        private

        # Create the B2B client
        def create_b2b_client
          project_id = Rails.application.credentials.dig(:stytch, :b2b, :project_id)
          secret = Rails.application.credentials.dig(:stytch, :b2b, :secret)
          unless project_id && secret
            raise PhcdevworksAccountsStytch::Stytch::Error.new(error_message: 'Stytch B2B credentials are missing')
          end

          StytchB2B::Client.new(
            project_id: project_id,
            secret: secret
          )
        end

        # Create the B2C client
        def create_b2c_client
          project_id = Rails.application.credentials.dig(:stytch, :b2c, :project_id)
          secret = Rails.application.credentials.dig(:stytch, :b2c, :secret)
          unless project_id && secret
            raise PhcdevworksAccountsStytch::Stytch::Error.new(error_message: 'Stytch B2C credentials are missing')
          end

          ::Stytch::Client.new(
            project_id: project_id,
            secret: secret
          )
        end
      end
    end
  end
end
