# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class MagicLinksController < ApplicationController
      include ErrorHandler
      include OrganizationSetter
      include HandleServiceAction

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

      def missing_login_or_signup_params?
        params[:email].blank? || @organization_id.blank?
      end

      def missing_invite_params?
        params[:email].blank? || @organization_id.blank?
      end

      def service
        PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService.new
      end
    end
  end
end
