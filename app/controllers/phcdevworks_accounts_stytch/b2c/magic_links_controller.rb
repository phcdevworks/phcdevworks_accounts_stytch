# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2c
    class MagicLinksController < ApplicationController
      include ErrorHandler
      include HandleServiceAction

      # Process Login or Signup
      def process_login_or_signup
        if params[:email].blank?
          handle_missing_params_error('Email is required')
          return
        end

        handle_service_action(:login_or_signup) do
          service.process_login_or_signup(params[:email])
        end
      end

      # Process Invite
      def process_invite
        if params[:email].blank?
          handle_missing_params_error('Email is required')
          return
        end

        handle_service_action(:invite) do
          service.process_invite(params[:email])
        end
      end

      # Process Revoke Invite
      def process_revoke_invite
        if params[:email].blank?
          handle_missing_params_error('Email is required')
          return
        end

        handle_service_action(:revoke_invite) do
          service.process_revoke_invite(params[:email])
        end
      end

      # Process Authenticate
      def process_authenticate
        if params[:token].blank?
          handle_missing_params_error('Magic Link token is required')
          return
        end

        handle_service_action(:authenticate) do
          service.process_authenticate(params[:token])
        end
      end

      private

      # Handle missing parameters error
      def handle_missing_params_error(message)
        log_error(message)
        render json: { error: message }, status: :unprocessable_entity
      end

      # Magic link service
      def service
        @service ||= PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService.new
      end

      # Log error
      def log_error(message)
        Rails.logger.error(message)
      end
    end
  end
end
