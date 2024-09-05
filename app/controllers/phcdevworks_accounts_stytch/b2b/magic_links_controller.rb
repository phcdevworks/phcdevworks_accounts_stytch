# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class MagicLinksController < ApplicationController
      before_action :set_organization, only: %i[process_login_or_signup process_invite]

      def authenticate
        if params[:token].blank?
          log_error('Missing magic link token')
          render json: { error: 'Magic link token is required.' }, status: :unprocessable_entity
        else
          redirect_to b2b_magic_links_process_authenticate_path(token: params[:token])
        end
      end

      def login_or_signup; end

      def process_login_or_signup
        if params[:email].blank? || @organization_id.blank?
          log_error('Missing email or organization slug')
          render json: { error: 'Email and Organization Slug are required.' }, status: :unprocessable_entity
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

      def handle_invite_action
        handle_service_action(:invite) do
          result = service.process_invite(params[:email], @organization_id, params[:session_token])
          Rails.logger.info("Invite successful: #{result.data}")
          result
        end
      end

      def handle_missing_params_error
        log_error('Missing email or organization slug')
        render json: { error: 'Email and Organization Slug are required.' }, status: :unprocessable_entity
      end

      def missing_required_params?
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
