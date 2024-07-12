# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    class ProcessorController < ApplicationController
      include StytchClient

      def create
        token = params[:token]
        response = stytch_client.magic_links.discovery.authenticate(discovery_magic_links_token: token)
        render plain: "Hello, #{response.email_address}! Complete the Discovery flow by creating an Organization with your intermediate session token: #{response.intermediate_session_token}."
      rescue StandardError => e
        render plain: e.message, status: :unauthorized
      end
    end
  end
end
