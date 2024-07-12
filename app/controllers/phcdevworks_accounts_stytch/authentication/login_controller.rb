# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    class LoginController < ApplicationController
      include StytchClient

      def create
        email = params[:email]
        response = send_magic_link(email)
        render json: response
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end

      private

      def send_magic_link(email)
        stytch_client.magic_links.email.discovery.send(email_address: email)
      end
    end
  end
end
