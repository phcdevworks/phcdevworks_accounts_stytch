# frozen_string_literal: true

require 'phcdevworks_accounts_stytch/stytch_client'

module PhcdevworksAccountsStytch
  module Authentication
    class ProcessorController < ApplicationController
      include StytchClient

      def create
        response = process_authentication
        render_success(response)
      rescue StandardError => e
        render_error(e)
      end

      private

      def process_authentication
        if magic_link_authentication?
          authenticate_magic_link(params[:magic_link_token])
        elsif google_authentication?
          authenticate_google(params[:google_token])
        else
          raise 'No authentication method provided'
        end
      end

      def magic_link_authentication?
        params[:magic_link_token].present?
      end

      def google_authentication?
        params[:google_token].present?
      end

      def authenticate_magic_link(token)
        stytch_client.magic_links.discovery.authenticate(discovery_magic_links_token: token)
      end

      def authenticate_google(token)
        google_client.verify_id_token(id_token: token)
      end

      def render_success(response)
        render plain: success_message(response)
      end

      def render_error(error)
        render plain: error.message, status: :unauthorized
      end

      def success_message(response)
        "Hello, #{response['email_address']}! Complete the Discovery flow by creating an " \
        "Organization with your intermediate session token: #{response['intermediate_session_token']}."
      end
    end
  end
end
