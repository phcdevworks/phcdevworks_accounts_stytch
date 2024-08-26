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
        handle_service_action(:login_or_signup) do
          service.process_login_or_signup(params[:email], params[:organization_id])
        end
      end

      def process_invite
        if params[:email].blank? || params[:organization_id].blank?
          log_error('Missing email or organization ID')
          render json: { error: 'Email and Organization ID are required.' }, status: :unprocessable_entity
          return
        end

        handle_service_action(:invite) do
          service.process_invite(params[:email], params[:organization_id], params[:session_token])
        end
      end

      def process_authenticate
        handle_service_action(:authenticate) do
          service.process_authenticate(params[:token])
        end
      end

      private

      def service
        @service ||= PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService.new
      end

      def handle_service_action(action_name)
        log_action_start(action_name)

        result = yield
        log_success(action_name, result)

        render json: { message: result.message, result: result.data }, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        log_error("#{action_name} failed", e)
        render json: { error: e.message }, status: e.status_code || :unprocessable_entity
      rescue StandardError => e
        log_error("Unexpected error during #{action_name}", e)
        render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
      end

      def log_action_start(action_name)
        Rails.logger.info "Starting #{action_name} action with params: #{params.inspect}"
      end

      def log_success(action_name, result)
        Rails.logger.info "#{action_name.capitalize} action successful: #{result.inspect}"
      end

      def log_error(message, error = nil)
        error_message = error ? "#{message}: #{error.message}" : message
        Rails.logger.error error_message
        Rails.logger.error error.backtrace.join("\n") if error
      end
    end
  end
end
