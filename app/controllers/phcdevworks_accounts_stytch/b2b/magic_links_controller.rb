# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class MagicLinksController < ApplicationController
      include ErrorHandler
      include OrganizationSetter
      include HandleServiceAction

      before_action :set_organization, only: %i[process_login_or_signup process_invite]

      # Login or Signup
      def login_or_signup; end

      # Process Login or Signup
      def process_login_or_signup
        if missing_login_or_signup_params?
          handle_missing_params_error('Organization slug is required')
          return
        end

        handle_service_action(:login_or_signup) do
          result = service.process_login_or_signup(params[:email], @organization_id)
          Rails.logger.info("Login or Signup successful: #{result.data}")
          result
        end
      end

      # Invite
      def invite; end

      # Process Invite
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

      # Check if email and organization ID are present
      def missing_login_or_signup_params?
        params[:email].blank? || @organization_id.blank?
      end

      # Check if email and organization ID are present
      def missing_invite_params?
        params[:email].blank? || @organization_id.blank?
      end

      # Magic Link service
      def service
        PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService.new
      end
    end
  end
end
