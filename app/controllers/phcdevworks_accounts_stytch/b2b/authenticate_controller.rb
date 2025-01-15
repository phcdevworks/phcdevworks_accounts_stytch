module PhcdevworksAccountsStytch
  module B2b
    class AuthenticateController < ApplicationController
      before_action :initialize_service

      # POST /phcdevworks_accounts_stytch/b2b/authenticate
      def create
        case params[:auth_type]
        when "magic_link"
          authenticate_magic_link
        when "password"
          authenticate_password
        when "sso"
          authenticate_sso
        when "oauth"
          authenticate_oauth
        when "session"
          authenticate_session
        else
          render json: {
            error: { error_code: "invalid_auth_type", error_message: "Unsupported auth type" }
          }, status: :bad_request
        end
      end

      # DELETE /phcdevworks_accounts_stytch/b2b/logout
      def destroy
        result = @service.handle_request do
          @service.client.sessions.revoke(
            session_token: params[:session_token]
          )
        end
        render json: result.to_h, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        render_error(e)
      end

      private

      def initialize_service
        @service = PhcdevworksAccountsStytch::Authentication::BaseService.new
      end

      def authenticate_magic_link
        result = @service.handle_request do
          @service.client.magic_links.authenticate(
            magic_links_token: params[:magic_links_token]
          )
        end
        render json: result.to_h, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        render_error(e)
      end

      def authenticate_password
        result = @service.handle_request do
          @service.client.passwords.authenticate(
            email_address: params[:email],
            password: params[:password]
          )
        end
        render json: result.to_h, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        render_error(e)
      end

      def authenticate_sso
        result = @service.handle_request do
          @service.client.sso.authenticate(
            sso_token: params[:sso_token],
            organization_id: params[:organization_id]
          )
        end
        render json: result.to_h, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        render_error(e)
      end

      def authenticate_oauth
        result = @service.handle_request do
          @service.client.oauth.authenticate(
            oauth_token: params[:oauth_token],
            organization_id: params[:organization_id]
          )
        end
        render json: result.to_h, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        render_error(e)
      end

      def authenticate_session
        result = @service.handle_request do
          @service.client.sessions.authenticate(
            session_token: params[:session_token]
          )
        end
        render json: result.to_h, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        render_error(e)
      end

      def render_error(error)
        render json: {
          error: {
            error_code: error.error_code || "unknown_error",
            error_message: error.error_message || "An unexpected error occurred"
          }
        }, status: error.status_code
      end
    end
  end
end
