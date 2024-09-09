# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class AuthenticateController < ApplicationController
      def authenticate
        if params[:token].present?
          redirect_to b2b_process_authenticate_path(token: params[:token])
        elsif params[:email].present? && params[:password].present? && params[:organization_id].present?
          redirect_to b2b_process_authenticate_path(email: params[:email], password: params[:password],
                                                    organization_id: params[:organization_id])
        else
          log_error('Missing credentials for authentication')
          render json: { error: 'Magic link token or email, password, and organization ID are required.' },
                 status: :unprocessable_entity
        end
      rescue StandardError => e
        log_error("Unexpected error during authentication: #{e.message}")
        render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
      end

      # The combined process_authenticate action
      def process_authenticate
        if params[:token].present?
          authenticate_with_magic_link
        elsif params[:email].present? && params[:password].present? && params[:organization_id].present?
          authenticate_with_password
        else
          log_error('Missing credentials for authentication')
          render json: { error: 'Magic link token or email, password, and organization ID are required.' },
                 status: :unprocessable_entity
        end
      rescue StandardError => e
        log_error("Unexpected error during authentication process: #{e.message}")
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
          result = password_service.authenticate_password(
            params[:email], params[:password], params[:organization_id]
          )
          Rails.logger.info("Password Authentication successful: #{result.inspect}")
          result
        end
      end

      def magic_link_service
        PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService.new
      end

      def password_service
        PhcdevworksAccountsStytch::Authentication::B2b::PasswordService.new
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
