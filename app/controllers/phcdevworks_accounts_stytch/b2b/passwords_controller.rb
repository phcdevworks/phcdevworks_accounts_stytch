# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class PasswordsController < ApplicationController
      before_action :set_organization, only: %i[reset_start reset_existing]

      def reset_start; end

      def process_reset_start
        if missing_reset_start_params?
          log_error('Missing email or organization slug')
          render json: { error: 'Email and Organization Slug are required.' }, status: :unprocessable_entity
          return
        end

        handle_service_action(:reset_start) do
          result = service.reset_start(params[:email], @organization_id)
          Rails.logger.info("Login or Signup successful: #{result.data}")
          result
        end
      end

      def reset_password; end

      def process_reset_password
        if missing_reset_password_params?
          log_error('Missing Token and Password.')
          render json: { error: 'Token and Password are required.' }, status: :unprocessable_entity
          return
        end

        handle_service_action(:reset) do
          result = service.reset(params[:token], params[:password])
          Rails.logger.info("Password Reset Successful: #{result.data}")
          result
        end
      end

      def reset_existing_password; end

      def process_reset_existing_password
        if missing_existing_password_params?
          log_error('Missing Email, old password, new password, and organization ID')
          render json: { error: 'Email, old password, new password, and organization ID are required.' },
                 status: :unprocessable_entity
          return
        end

        handle_service_action(:reset_existing) do
          result = service.reset_existing(params[:email], params[:old_password], params[:new_password], @organization_id)
          Rails.logger.info("Password Reset Successful: #{result.data}")
          result
        end
      end

      def reset_with_session; end

      def process_reset_with_session
        if missing_reset_with_session_params?
          log_error('Missing Session token, new password, and organization ID')
          render json: { error: 'Session token, new password, and organization ID are required.' }, status: :unprocessable_entity
          return
        end

        handle_service_action(:reset_with_session) do
          result = service.reset_with_session(params[:session_token], params[:password], @organization_id)
          Rails.logger.info("Password Reset Successful: #{result.data}")
          result
        end
      end

      private

      def set_organization
        organization_service = PhcdevworksAccountsStytch::Stytch::Organization.new
        @organization_id = organization_service.find_organization_id_by_slug(params[:organization_slug])
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        log_error(e.message)
        render json: { error: e.message }, status: :not_found
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

      def missing_reset_start_params?
        params[:email].blank? || @organization_id.blank?
      end

      def missing_reset_password_params?
        params[:token].blank? || params[:password].blank?
      end

      def missing_existing_password_params?
        params[:email].blank? || params[:old_password].blank? || params[:new_password].blank? || @organization_id.blank?
      end

      def missing_reset_with_session_params?
        params[:session_token].blank? || params[:password].blank? || @organization_id.blank?
      end

      def service
        PhcdevworksAccountsStytch::Authentication::B2b::PasswordService.new
      end

      def log_error(message)
        Rails.logger.error(message)
      end
    end
  end
end
