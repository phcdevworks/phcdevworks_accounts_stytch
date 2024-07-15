# frozen_string_literal: true

require 'phcdevworks_accounts_stytch/stytch_client'

module PhcdevworksAccountsStytch
  module Authentication
    class LoginController < ApplicationController
      include StytchClient

      def create
        response = process_login
        render json: response
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end

      private

      def process_login
        if email_login?
          send_magic_link(params[:email])
        elsif google_login?
          authenticate_google(params[:google_token])
        else
          raise 'No login method provided'
        end
      end

      def email_login?
        params[:email].present?
      end

      def google_login?
        params[:google_token].present?
      end

      def send_magic_link(email)
        stytch_client.magic_links.email.discovery.send(email_address: email)
      end

      def authenticate_google(token)
        google_client.verify_id_token(id_token: token)
      end
    end
  end
end
