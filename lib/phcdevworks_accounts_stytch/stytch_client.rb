# frozen_string_literal: true

module PhcdevworksAccountsStytch
  class StytchClient
    class << self
      def b2b_client
        @b2b_client ||= create_b2b_client
      end

      def b2c_client
        @b2c_client ||= create_b2c_client
      end

      private

      def create_b2b_client
        project_id = Rails.application.credentials.dig(:stytch, :b2b, :project_id)
        secret = Rails.application.credentials.dig(:stytch, :b2b, :secret)
        raise 'Stytch B2B credentials are missing' unless project_id && secret

        StytchB2B::Client.new(
          project_id: project_id,
          secret: secret
        )
      end

      def create_b2c_client
        project_id = Rails.application.credentials.dig(:stytch, :b2c, :project_id)
        secret = Rails.application.credentials.dig(:stytch, :b2c, :secret)
        raise 'Stytch B2C credentials are missing' unless project_id && secret

        Stytch::Client.new(
          project_id: project_id,
          secret: secret
        )
      end
    end
  end
end
