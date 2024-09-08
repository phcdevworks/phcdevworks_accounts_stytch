# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class PasswordsController < ApplicationController
      def authenticate
        if missing_required_params?
          log_error('Missing email, password, or organization ID')
          render json: { error: 'Email, password, and organization ID are required.' }, status: :unprocessable_entity
        else
          redirect_to b2b_passwords_process_authenticate_path(email: params[:email], password: params[:password],
                                                              organization_id: params[:organization_id])
        end
      end

      def process_authenticate
        if missing_required_params?
          log_error('Missing email, password, or organization ID')
          render json: { error: 'Email, password, and organization ID are required.' }, status: :unprocessable_entity
          return
        end

        handle_service_action(:authenticate) do
          result = service.authenticate_password(params[:email], params[:password], params[:organization_id])
          Rails.logger.info("B2B Authentication successful: #{result.inspect}")
          result
        end
      rescue StandardError => e
        Rails.logger.error("Unexpected error in process_authenticate: #{e.message}")
        render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
      end

      private

      def missing_required_params?
        params[:email].blank? || params[:password].blank? || params[:organization_id].blank?
      end

      def service
        PhcdevworksAccountsStytch::Authentication::B2b::PasswordService.new
      end

      def log_error(message)
        Rails.logger.error(message)
      end

      def handle_service_action(action_name)
        result = yield
        if result.is_a?(Hash) && result.key?(:message)
          render json: { message: result[:message], data: result[:data] }, status: :ok
        else
          render json: { message: 'Action completed successfully', data: result }, status: :ok
        end
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
