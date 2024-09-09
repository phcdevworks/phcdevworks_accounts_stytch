# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2c
    class AuthenticateController < ApplicationController
      def authenticate
        if params[:token].present?
          authenticate_with_magic_link
        elsif params[:email].present? && params[:password].present?
          authenticate_with_password
        else
          log_error('Missing credentials for authentication')
          render json: { error: 'Either magic link token or email and password are required.' }, status: :unprocessable_entity
        end
      rescue StandardError => e
        log_error("Unexpected error during authentication: #{e.message}")
        render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
      end

      private

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

      def log_error(message)
        Rails.logger.error(message)
      end

      def handle_service_action(action_name)
        result = yield
        render json: { message: result.message, data: result.data }, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        log_error("Stytch API error during #{action_name}: #{e.message}")
        render json: { error: e.message }, status: :bad_request
      rescue StandardError => e
        log_error("Unexpected error during #{action_name}: #{e.message}")
        render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
      end
    end
  end
end
