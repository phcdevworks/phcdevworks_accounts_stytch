# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class PasswordsController < ApplicationController
      before_action :set_organization, only: %i[reset_start reset_existing]

      def reset_start_form; end

      def reset_start
        if params[:email].blank? || @organization_id.blank?
          render_error('Email and Organization ID are required.')
          return
        end

        handle_service_action(:reset_start) do
          service.reset_start(params[:email], @organization_id)
        end
      end

      def reset_form; end

      def reset_process
        if params[:token].blank? || params[:password].blank?
          render_error('Token and Password are required.')
          return
        end

        handle_service_action(:reset) do
          service.reset(params[:token], params[:password])
        end
      end

      def reset_existing_password_form; end

      def reset_existing_password
        if missing_existing_password_params?
          render_error('Email, old password, new password, and organization ID are required.')
          return
        end

        handle_service_action(:reset_existing) do
          service.reset_existing(params[:email], params[:old_password], params[:new_password], @organization_id)
        end
      end

      def reset_with_session_form; end

      def reset_with_session
        if params[:session_token].blank? || params[:password].blank? || @organization_id.blank?
          render_error('Session token, new password, and organization ID are required.')
          return
        end

        handle_service_action(:reset_with_session) do
          service.reset_with_session(params[:session_token], params[:password], @organization_id)
        end
      end

      private

      def missing_existing_password_params?
        params[:email].blank? || params[:old_password].blank? || params[:new_password].blank? || @organization_id.blank?
      end

      def set_organization
        organization_service = PhcdevworksAccountsStytch::Stytch::Organization.new
        @organization_id = organization_service.find_organization_id_by_slug(params[:organization_slug])
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        log_error(e.message)
        render json: { error: e.message }, status: :not_found
      end

      def find_organization_id(slug)
        organization_service = PhcdevworksAccountsStytch::Stytch::Organization.new
        organization_service.find_organization_id_by_slug(slug)
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

      def handle_missing_params_error
        log_error('Missing email or organization slug')
        render json: { error: 'Email and Organization Slug are required.' }, status: :unprocessable_entity
      end

      def missing_required_params?
        params[:email].blank? || @organization_id.blank?
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
