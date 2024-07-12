# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    class ProcessorController < ApplicationController
      include StytchClient

      def create
        token = params[:token]
        response = authenticate_token(token)
        render_success(response)
      rescue StandardError => e
        render_error(e)
      end

      private

      def authenticate_token(token)
        stytch_client.magic_links.discovery.authenticate(discovery_magic_links_token: token)
      end

      def render_success(response)
        render plain: success_message(response)
      end

      def render_error(error)
        render plain: error.message, status: :unauthorized
      end

      def success_message(response)
        "Hello, #{response.email_address}! Complete the Discovery flow by creating an " \
        "Organization with your intermediate session token: #{response.intermediate_session_token}."
      end
    end
  end
end
