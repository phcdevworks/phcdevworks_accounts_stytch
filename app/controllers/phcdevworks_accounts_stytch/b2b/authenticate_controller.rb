# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class AuthenticateController < ApplicationController
      include ErrorHandler
      include HandleServiceAction

      # Authentication for magic link and password
      def authenticate
        if magic_link_token_present?
          handle_magic_link_authentication
        elsif email_password_and_organization_present?
          handle_password_authentication
        else
          handle_missing_credentials
        end
      rescue PhcdevworksAccountsStytch::Stytch::ServerError => e
        handle_server_error(e)
      rescue StandardError => e
        handle_unexpected_error(e)
      end

      # Process authentication for magic link and password
      def process_authenticate
        if magic_link_token_present?
          authenticate_with_magic_link
        elsif email_password_and_organization_present?
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

      # Check if magic link token is present
      def magic_link_token_present?
        params[:token].present?
      end

      # Check if email, password, and organization ID are present
      def email_password_and_organization_present?
        params[:email].present? && params[:password].present? && params[:organization_id].present?
      end

      # Handle magic link authentication
      def handle_magic_link_authentication
        redirect_to b2b_process_authenticate_path(
          token: params[:token]
        )
      end

      # Handle password authentication
      def handle_password_authentication
        redirect_to b2b_process_authenticate_path(
          email: params[:email], password: params[:password],
          organization_id: params[:organization_id]
        )
      end

      # Handle missing credentials
      def handle_missing_credentials
        handle_missing_params_error('Magic link token or email, password, and organization ID are required.')
      end

      # Authenticate with magic link
      def authenticate_with_magic_link
        handle_service_action(:magic_link_authenticate) do
          result = magic_link_service.process_authenticate(params[:token])
          Rails.logger.info("Magic Link Authentication successful: #{result.data}")
          result
        end
      end

      # Authenticate with password
      def authenticate_with_password
        handle_service_action(:password_authenticate) do
          result = password_service.authenticate_password(params[:email], params[:password], params[:organization_id])
          Rails.logger.info("Password Authentication successful: #{result.inspect}")
          result
        end
      end

      # Magic link service
      def magic_link_service
        PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService.new
      end

      # Password service
      def password_service
        PhcdevworksAccountsStytch::Authentication::B2b::PasswordService.new
      end

      # Handle missing parameters error
      def handle_server_error(servererror)
        log_error("Server error occurred: #{servererror.message}")
        render json: { error: servererror.message }, status: servererror.status_code
      end

      # Handle unexpected error
      def handle_unexpected_error(unexpectederror)
        log_error("Unexpected error occurred: #{unexpectederror.message}")
        render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
      end
    end
  end
end
