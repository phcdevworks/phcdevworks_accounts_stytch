# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2c
    class MagicLinksController < ApplicationController
      # Login or signup with magic link
      def login_or_signup; end

      # Process login or signup with magic link
      def process_login_or_signup
        if params[:email].blank?
          handle_missing_params_error
          return
        end

        handle_service_action(:login_or_signup) do
          result = service.process_login_or_signup(params[:email])
          Rails.logger.info("Login or Signup successful: #{result[:message]}")
          result
        end
      end

      # Invite with magic link
      def invite; end

      # Process invite with magic link
      def process_invite
        if missing_required_params?
          handle_missing_params_error
          return
        end

        handle_service_action(:invite) do
          result = service.process_invite(params[:email])
          Rails.logger.info("Invite successful: #{result[:message]}")
          result
        end
      end

      # Revoke invite with magic link
      def process_revoke_invite
        if missing_required_params?
          handle_missing_params_error
          return
        end

        handle_service_action(:revoke_invite) do
          result = service.process_revoke_invite(params[:email])
          Rails.logger.info("Revoke invite successful: #{result[:message]}")
          result
        end
      end

      private

      # Handle service action
      def handle_service_action(action_name)
        result = yield
        render json: { message: result[:message], data: result[:data] }, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        log_error("Stytch API error during #{action_name}: #{e.message}")
        render json: { error: e.message }, status: :bad_request
      rescue StandardError => e
        log_error("Unexpected error during #{action_name}: #{e.message}")
        render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
      end

      # Handle missing parameters error
      def handle_missing_params_error
        log_error('Missing email')
        render json: { error: 'Email is required.' }, status: :unprocessable_entity
      end

      # Check if required parameters are missing
      def missing_required_params?
        params[:email].blank?
      end

      # Magic link service
      def service
        PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService.new
      end

      # Log error
      def log_error(message)
        Rails.logger.error(message)
      end
    end
  end
end
