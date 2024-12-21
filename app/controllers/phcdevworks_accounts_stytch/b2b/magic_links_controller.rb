# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class MagicLinksController < ApplicationController
      include ErrorHandler
      include OrganizationSetter
      include HandleServiceAction

      before_action :set_organization, only: %i[process_login_or_signup process_invite]

      # Process Login or Signup
      def process_login_or_signup
        handle_service_action(:login_or_signup) do
          service.process_login_or_signup(params[:email], @organization_id)
        end
      end

      # Process Invite
      def process_invite
        handle_service_action(:invite) do
          service.process_invite(params[:email], @organization_id, params[:session_token])
        end
      end

      private

      # Check if required parameters are present
      def missing_login_or_signup_params?
        params[:email].blank? || @organization_id.blank?
      end

      def missing_invite_params?
        params[:email].blank? || @organization_id.blank? || params[:session_token].blank?
      end

      # Magic Link service
      def service
        @service ||= PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService.new
      end
    end
  end
end
