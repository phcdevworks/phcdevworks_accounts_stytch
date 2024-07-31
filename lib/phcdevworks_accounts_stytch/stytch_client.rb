# frozen_string_literal: true

require 'stytch'

module PhcdevworksAccountsStytch
  class StytchClient
    def self.client
      @client ||= StytchB2B::Client.new(
        project_id: Rails.application.credentials.dig(:stytch, :project_id),
        secret: Rails.application.credentials.dig(:stytch, :secret)
      )
    end
  end
end
