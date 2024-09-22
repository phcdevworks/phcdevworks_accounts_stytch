# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2c
    class AuthenticateController < ApplicationController
      include ErrorHandler
      include HandleServiceAction

      def authenticate
        if magic_link_token_present?
          handle_magic_link_authentication
        elsif email_and_password_present?
          handle_password_authentication
        else
          handle_missing_credentials
        end
      rescue PhcdevworksAccountsStytch::Stytch::ServerError => e
        handle_server_error(e)
      rescue StandardError => e
        handle_unexpected_error(e)
      end

      def process_authenticate
        if magic_link_token_present?
          authenticate_with_magic_link
        elsif email_and_password_present?
          authenticate_with_password
        else
          handle_missing_credentials
        end
      rescue PhcdevworksAccountsStytch::Stytch::ServerError => e
        handle_server_error(e)
      rescue StandardError => e
        handle_unexpected_error(e)
      end

      private

      def magic_link_token_present?
        params[:token].present?
      end

      def email_and_password_present?
        params[:email].present? && params[:password].present?
      end

      def handle_magic_link_authentication
        redirect_to b2c_process_authenticate_path(token: params[:token])
      end

      def handle_password_authentication
        redirect_to b2c_process_authenticate_path(email: params[:email], password: params[:password])
      end

      def handle_missing_credentials
        log_error('Missing credentials for authentication')
        render json: { error: 'Magic link token or email and password are required.' },
               status: :unprocessable_entity
      end

      def authenticate_with_magic_link
        handle_service_action(:magic_link_authenticate) do
          result = magic_link_service.process_authenticate(params[:token])
          Rails.logger.info("Magic Link Authentication successful: #{result.data}")
          result
        end
      end

      def authenticate_with_password
        handle_service_action(:password_authenticate) do
          result = password_service.authenticate_password(params[:email], params[:password])
          Rails.logger.info("Password Authentication successful: #{result.inspect}")
          result
        end
      end

      def magic_link_service
        PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService.new
      end

      def password_service
        PhcdevworksAccountsStytch::Authentication::B2c::PasswordService.new
      end

      def handle_server_error(e)
        log_error("Server error occurred: #{e.message}")
        render json: { error: e.message }, status: e.status_code
      end

      def handle_unexpected_error(e)
        log_error("Unexpected error occurred: #{e.message}")
        render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
      end
    end
  end
end
