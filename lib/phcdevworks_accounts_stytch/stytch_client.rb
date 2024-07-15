# frozen_string_literal: true

require 'stytch'

module StytchClient
  def stytch_client
    @stytch_client ||= Stytch::Client.new(
      project_id: PhcdevworksAccountsStytch.configuration.project_id,
      secret: PhcdevworksAccountsStytch.configuration.secret
    )
  end

  def google_client
    @google_client ||= Google::Client.new(
      client_id: PhcdevworksAccountsStytch.configuration.google_client_id,
      client_secret: PhcdevworksAccountsStytch.configuration.google_client_secret
    )
  end
end
