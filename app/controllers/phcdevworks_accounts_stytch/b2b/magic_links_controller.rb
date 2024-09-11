# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class MagicLinksController < ApplicationController
      before_action :set_organization, only: %i[process_login_or_signup process_invite]

      def login_or_signup; end

      def process_login_or_signup
        if missing_login_or_signup_params?
          handle_missing_params_error('Email and Organization Slug are required.')
          return
        end

        handle_service_action(:login_or_signup) do
          result = service.process_login_or_signup(params[:email], @organization_id)
          Rails.logger.info("Login or Signup successful: #{result.data}")
          result
        end
      end

      def invite; end

      def process_invite
        if missing_invite_params?
          handle_missing_params_error('Email and Organization Slug are required.')
          return
        end

        handle_service_action(:invite) do
          result = service.process_invite(params[:email], @organization_id, params[:session_token])
          Rails.logger.info("Invite successful: #{result.data}")
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

      def handle_missing_params_error(message)
        log_error(message)
        render json: { error: message }, status: :unprocessable_entity
      end

      def missing_login_or_signup_params?
        params[:email].blank? || @organization_id.blank?
      end

      def missing_invite_params?
        params[:email].blank? || @organization_id.blank?
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
