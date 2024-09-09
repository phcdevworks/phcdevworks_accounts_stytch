# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class PasswordsController < ApplicationController
      before_action :set_organization, only: %i[reset_start reset_existing_password reset_with_session]

      # Step 1: GET action to render the form for starting password reset via email
      def reset_start_form
        # Render the form for the user to input their email and organization_slug
        render 'b2b/passwords/reset_start_form'
      end

      # Step 2: POST action to send a password reset email
      def reset_start
        if params[:email].blank? || @organization_id.blank?
          log_error('Missing email or organization slug')
          render json: { error: 'Email and Organization Slug are required.' }, status: :unprocessable_entity
          return
        end

        handle_service_action(:reset_start) do
          result = password_service.reset_start(params[:email], @organization_id)
          Rails.logger.info("Password reset email sent successfully: #{result.data}")
          result
        end
      end

      # Step 3: GET action to render the password reset form (using token)
      def reset_form
        # Render the form for the user to input their reset token and new password
        render 'b2b/passwords/reset_form'
      end

      # Step 4: POST action to reset the password using the token
      def reset_process
        if params[:token].blank? || params[:password].blank? || params[:organization_id].blank?
          log_error('Missing token, new password, or organization_id')
          render json: { error: 'Token, new password, and organization_id are required.' }, status: :unprocessable_entity
          return
        end

        handle_service_action(:reset_process) do
          result = password_service.reset_with_token(params[:token], params[:password], params[:organization_id])
          Rails.logger.info("Password reset successful: #{result.data}")
          result
        end
      end

      # Step 5: GET action to render the form for resetting the password using the existing password
      def reset_existing_password_form
        # Render the form for the user to input their existing password and new password
        render 'b2b/passwords/reset_existing_password_form'
      end

      # Step 6: POST action to reset the password using the existing password
      def reset_existing_password
        if params[:email].blank? || params[:existing_password].blank? || params[:new_password].blank? || @organization_id.blank?
          log_error('Missing required parameters for existing password reset')
          render json: { error: 'Email, existing password, new password, and organization slug are required.' },
                 status: :unprocessable_entity
          return
        end

        handle_service_action(:reset_existing_password) do
          result = password_service.reset_with_existing_password(params[:email], params[:existing_password],
                                                                 params[:new_password], @organization_id)
          Rails.logger.info("Password reset using existing password successful: #{result.data}")
          result
        end
      end

      # Step 7: GET action to render the form for resetting password using a session token
      def reset_with_session_form
        # Render the form for the user to input their session token and new password
        render 'b2b/passwords/reset_with_session_form'
      end

      # Step 8: POST action to reset the password using a session token
      def reset_with_session
        if params[:session_token].blank? || params[:password].blank? || @organization_id.blank?
          log_error('Missing session token or new password')
          render json: { error: 'Session token, new password, and organization slug are required.' },
                 status: :unprocessable_entity
          return
        end

        handle_service_action(:reset_with_session) do
          result = password_service.reset_with_session(params[:session_token], params[:password], @organization_id)
          Rails.logger.info("Password reset using session token successful: #{result.data}")
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
        render json: { message: result.message, data: result.data }, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        log_error("Stytch API error during #{action_name}: #{e.message}")
        render json: { error: e.message }, status: :bad_request
      rescue StandardError => e
        log_error("Unexpected error during #{action_name}: #{e.message}")
        render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
      end

      def password_service
        PhcdevworksAccountsStytch::Authentication::B2b::PasswordService.new
      end

      def log_error(message)
        Rails.logger.error(message)
      end
    end
  end
end
