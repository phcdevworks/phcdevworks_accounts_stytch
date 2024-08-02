# frozen_string_literal: true

module PhcdevworksAccountsStytch
  class StytchClient
    def self.b2b_client
      project_id = Rails.application.credentials.dig(:stytch, :b2b, :project_id)
      secret = Rails.application.credentials.dig(:stytch, :b2b, :secret)

      raise 'Stytch B2B credentials are missing' unless project_id && secret

      @b2b_client ||= StytchB2B::Client.new(
        project_id: project_id,
        secret: secret
      )
    end

    def self.b2c_client
      project_id = Rails.application.credentials.dig(:stytch, :b2c, :project_id)
      secret = Rails.application.credentials.dig(:stytch, :b2c, :secret)

      raise 'Stytch B2C credentials are missing' unless project_id && secret

      @b2c_client ||= Stytch::Client.new(
        project_id: project_id,
        secret: secret
      )
    end
  end
end
