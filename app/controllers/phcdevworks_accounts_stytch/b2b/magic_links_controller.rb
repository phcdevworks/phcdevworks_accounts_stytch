# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class MagicLinksController < ApplicationController
      # PHCDEVONE - Page Views
      def invite; end

      def authenticate; end

      def login_or_signup; end

      # PHCDEVONE - Processing Actions
      def process_login_or_signup
        if params[:email].blank? || params[:organization_id].blank?
          log_error('Missing email or organization ID')
          render json: { error: 'Email and Organization ID are required.' }, status: :unprocessable_entity
          return
        end

        handle_service_action(:login_or_signup) do
          result = service.process_login_or_signup(params[:email], params[:organization_id])
          Rails.logger.info("Login or Signup successful: #{result.data}")
          result
        end
      end

      def process_invite
        if missing_required_params?
          handle_missing_params_error
          return
        end

        handle_invite_action
      end

      def process_authenticate
        if params[:token].blank?
          log_error('Missing magic link token')
          render json: { error: 'Magic link token is required.' }, status: :unprocessable_entity
          return
        end

        handle_service_action(:authenticate) do
          result = service.process_authenticate(params[:token])
          Rails.logger.info("Authentication successful: #{result.data}")
          result
        end
      end

      private

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

      def handle_invite_action
        handle_service_action(:invite) do
          result = service.process_invite(params[:email], params[:organization_id], params[:session_token])
          Rails.logger.info("Invite successful: #{result.data}")
          result
        end
      end

      def handle_missing_params_error
        log_error('Missing email or organization ID')
        render json: { error: 'Email and Organization ID are required.' }, status: :unprocessable_entity
      end

      def missing_required_params?
        params[:email].blank? || params[:organization_id].blank?
      end

      def service
        PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService.new
      end

      def log_error(message)
        Rails.logger.error(message)
      end
    end
  end
end
