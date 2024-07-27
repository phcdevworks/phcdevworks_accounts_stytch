# frozen_string_literal: true

module PhcdevworksAccountsStytch
  class StytchClient
    def self.client
      @client ||= Stytch::Client.new(
        project_id: Rails.application.credentials.dig(:stytch, :project_id),
        secret: Rails.application.credentials.dig(:stytch, :secret)
      )
    end
  end
end
