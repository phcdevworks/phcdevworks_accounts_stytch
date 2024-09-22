# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2c
    class MagicLinksController < ApplicationController
      def login_or_signup; end

      def process_login_or_signup
        if params[:email].blank?
          log_error('Missing email')
          render json: { error: 'Email is required.' }, status: :unprocessable_entity
          return
        end

        handle_service_action(:login_or_signup) do
          result = service.process_login_or_signup(params[:email])
          Rails.logger.info("Login or Signup successful: #{result.data}")
          result
        end
      end

      def invite; end

      def process_invite
        if missing_required_params?
          handle_missing_params_error
          return
        end

        handle_invite_action
      end

      def process_revoke_invite
        if params[:email].blank?
          log_error('Missing email')
          render json: { error: 'Email is required.' }, status: :unprocessable_entity
          return
        end

        handle_service_action(:revoke_invite) do
          result = service.process_revoke_invite(params[:email])
          if result.is_a?(Hash) && result.key?(:data)
            Rails.logger.info("Revoke invite successful: #{result[:data]}")
          else
            Rails.logger.info("Revoke invite successful: #{result.data}")
          end
          result
        end
      end

      private

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

      def handle_invite_action
        handle_service_action(:invite) do
          result = service.process_invite(params[:email])
          Rails.logger.info("Invite successful: #{result.data}")
          result
        end
      end

      def handle_missing_params_error
        log_error('Missing email')
        render json: { error: 'Email is required.' }, status: :unprocessable_entity
      end

      def missing_required_params?
        params[:email].blank?
      end

      def service
        PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService.new
      end

      def log_error(message)
        Rails.logger.error(message)
      end
    end
  end
end
