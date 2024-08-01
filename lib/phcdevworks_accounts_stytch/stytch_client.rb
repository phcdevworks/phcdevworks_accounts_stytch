# lib/phcdevworks_accounts_stytch/stytch_client.rb

module PhcdevworksAccountsStytch
  class StytchClient
    def self.client
      project_id = Rails.application.credentials.dig(:stytch, :project_id)
      secret = Rails.application.credentials.dig(:stytch, :secret)

      raise 'Stytch credentials are missing' unless project_id && secret

      @client ||= StytchB2B::Client.new(
        project_id: project_id,
        secret: secret
      )
    end
  end
end
