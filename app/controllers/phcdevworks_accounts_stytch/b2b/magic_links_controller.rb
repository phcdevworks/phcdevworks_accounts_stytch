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
          Rails.logger.warn 'Login/Signup attempt failed: Missing email parameter'
          render json: { error: 'Email is required' }, status: :unprocessable_entity
          return
        end

        Rails.logger.info "Processing Login or Signup for email: #{params[:email]}"
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
          Rails.logger.warn "Invite attempt failed: #{message}"
          render json: { error: message }, status: :unprocessable_entity
          return
        end

        Rails.logger.info "Processing invite for email: #{params[:email]} in organization: #{@organization_id}"
        handle_service_action(:invite) do
          service.process_invite(params[:email], @organization_id, params[:session_token])
        end
      end

      # Process Revoke Invite
      def process_revoke_invite
        if params[:email].blank?
          Rails.logger.warn 'Revoke invite attempt failed: Missing email parameter'
          render json: { error: 'Email is required to revoke invite' }, status: :unprocessable_entity
          return
        end

        Rails.logger.info "Processing revoke invite for email: #{params[:email]} in organization: #{@organization_id}"
        handle_service_action(:revoke_invite) do
          service.process_revoke_invite(params[:email], @organization_id)
        end
      end

      private

      # Magic Link service
      def service
        @service ||= PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService.new
      end
    end
  end
end
