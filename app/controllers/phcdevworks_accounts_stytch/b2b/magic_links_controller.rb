# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class MagicLinksController < ApplicationController
      include ErrorHandler
      include OrganizationSetter
      include HandleServiceAction
      before_action :set_organization, only: %i[process_invite]

      # Process Login or Signup
      def process_login_or_signup
        if params[:email].blank?
          render json: { error: 'Email is required' }, status: :unprocessable_entity
          return
        end

        handle_service_action(:login_or_signup) do
          service.process_login_or_signup(params[:email], @organization_id)
        end
      end

      # Process Invite
      def process_invite
        missing_params = []
        missing_params << 'Email' if params[:email].blank?
        missing_params << 'Organization Slug' if @organization_id.blank?
        missing_params << 'Session Token' if params[:session_token].blank?

        if missing_params.any?
          message = if missing_params.size == 1
                      "#{missing_params.first} is required"
                    else
                      "#{missing_params.to_sentence(last_word_connector: ', and ')} are required"
                    end
          render json: { error: message }, status: :unprocessable_entity
          return
        end

        handle_service_action(:invite) do
          service.process_invite(params[:email], @organization_id, params[:session_token])
        end
      end

      # Process Revoke Invite
      def process_revoke_invite
        if params[:email].blank?
          render json: { error: 'Email is required to revoke invite' }, status: :unprocessable_entity
          return
        end

        handle_service_action(:revoke_invite) do
          service.process_revoke_invite(params[:email], @organization_id)
        end
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        render json: {
          error: "Stytch Error (Status Code: #{e.status_code}) - Code: #{e.error_code} - Message: #{e.error_message}",
          code: e.error_code,
          details: e.to_h
        }, status: e.status_code
      end

      private

      # Magic Link service
      def service
        @service ||= PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService.new
      end
    end
  end
end
