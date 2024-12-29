module PhcdevworksAccountsStytch
  module B2b
    class AuthenticateController < ApplicationController
      before_action :initialize_service

      # POST /phcdevworks_accounts_stytch/b2b/authenticate
      def create
        result = @service.handle_request do
          @service.client.sessions.authenticate(
            session_token: params[:session_token]
          )
        end
        render json: result.to_h, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        render json: { error: e.to_h }, status: e.status_code
      end

      # POST /phcdevworks_accounts_stytch/b2b/logout
      def destroy
        result = @service.handle_request do
          @service.client.sessions.revoke(
            session_token: params[:session_token]
          )
        end
        render json: result.to_h, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        render json: { error: e.to_h }, status: e.status_code
      end

      private

      def initialize_service
        @service = PhcdevworksAccountsStytch::Authentication::BaseService.new
      end
    end
  end
end
