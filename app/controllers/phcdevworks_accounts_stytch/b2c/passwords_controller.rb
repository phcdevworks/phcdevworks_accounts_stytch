# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2c
    class PasswordsController < ApplicationController
      include ErrorHandler
      include HandleServiceAction

      # Reset Start
      def reset_start; end

      # Process Reset Start
      def process_reset_start
        if missing_reset_start_params?
          handle_missing_params_error('Email is required.')
          return
        end

        handle_service_action(:reset_start) do
          result = service.reset_start(params[:email])
          Rails.logger.info("Password Reset Start successful: #{result.data}")
          result
        end
      end

      # Reset Password
      def reset_password; end

      # Process Reset Password
      def process_reset_password
        if missing_reset_password_params?
          handle_missing_params_error('Token and Password are required.')
          return
        end

        handle_service_action(:reset_password) do
          result = service.reset(params[:token], params[:password])
          Rails.logger.info("Password Reset Successful: #{result.data}")
          result
        end
      end

      # Reset Existing Password
      def reset_existing_password; end

      # Process Reset Existing Password
      def process_reset_existing_password
        if missing_existing_password_params?
          handle_missing_params_error('Email, old password, and new password are required.')
          return
        end

        handle_service_action(:reset_existing_password) do
          result = service.reset_existing(params[:email], params[:old_password], params[:new_password])
          Rails.logger.info("Existing Password Reset Successful: #{result.data}")
          result
        end
      end

      # Reset with Session
      def reset_with_session; end

      # Process Reset with Session
      def process_reset_with_session
        if missing_reset_with_session_params?
          handle_missing_params_error('Session token and new password are required.')
          return
        end

        handle_service_action(:reset_with_session) do
          result = service.reset_with_session(params[:session_token], params[:password])
          Rails.logger.info("Session-based Password Reset Successful: #{result.data}")
          result
        end
      end

      private

      # Check if email is present
      def missing_reset_start_params?
        params[:email].blank?
      end

      # Check if token and password are present
      def missing_reset_password_params?
        params[:token].blank? || params[:password].blank?
      end

      # Check if email, old password, and new password are present
      def missing_existing_password_params?
        params[:email].blank? || params[:old_password].blank? || params[:new_password].blank?
      end

      # Check if session token and password are present
      def missing_reset_with_session_params?
        params[:session_token].blank? || params[:password].blank?
      end

      # Password service
      def service
        PhcdevworksAccountsStytch::Authentication::B2c::PasswordService.new
      end
    end
  end
end
