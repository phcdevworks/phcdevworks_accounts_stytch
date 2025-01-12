module PhcdevworksAccountsStytch
  module B2b
    class SsoController < ApplicationController
      before_action :initialize_service

      # POST /phcdevworks_accounts_stytch/b2b/:organization_slug/sso/authenticate
      def authenticate
        result = @service.handle_request do
          @service.client.sso.authenticate(
            organization_slug: params[:organization_slug],
            connection_id: params[:connection_id],
            idp_response: params[:idp_response]
          )
        end
        render json: result.to_h, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        render json: { error: e.to_h }, status: e.status_code
      end

      private

      def initialize_service
        @service = PhcdevworksAccountsStytch::Authentication::B2b::SsoService.new
      end
    end
  end
end