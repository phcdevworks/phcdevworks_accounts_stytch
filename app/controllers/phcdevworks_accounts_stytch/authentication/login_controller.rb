# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    class LoginController < ApplicationController
      include StytchClient

      def create
        email = params[:email]
        response = stytch_client.magic_links.email.discovery.send(
          email_address: email
        )
        render json: response
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end
    end
  end
end
