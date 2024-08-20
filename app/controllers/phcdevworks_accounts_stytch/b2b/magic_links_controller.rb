# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class MagicLinksController < ApplicationController
      # PHCDEVONE - Page Views
      def invite; end

      def authenticate; end

      def login_or_signup; end

      # PHCDEVONE - Processing Actions
      def process_login_or_signup
        handle_service_action do
          service.process_login_or_signup(params[:email], params[:organization_id])
        end
      end

      def process_invite
        if params[:email].blank? || params[:organization_id].blank?
          render json: { error: 'Email and Organization ID are required.' }, status: :unprocessable_entity
          return
        end

        handle_service_action do
          service.process_invite(params[:email], params[:organization_id], params[:session_token])
        end
      end

      def process_authenticate
        handle_service_action do
          service.process_authenticate(params[:token])
        end
      end

      private

      def service
        @service ||= PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService.new
      end

      def handle_service_action
        result = yield
        render json: { message: 'Action completed successfully.', result: result }, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        render json: { error: e.message }, status: e.status_code || :unprocessable_entity
      end
    end
  end
end
