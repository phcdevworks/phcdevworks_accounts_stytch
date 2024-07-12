# frozen_string_literal: true

module StytchClient
  def stytch_client
    @stytch_client ||= StytchB2B::Client.new(
      project_id: StytchClientConfig.project_id,
      secret: StytchClientConfig.secret
    )
  end
end
