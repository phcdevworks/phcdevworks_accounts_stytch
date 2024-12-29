module PhcdevworksAccountsStytch
  module B2b
    class MagicLinksController < ApplicationController
      before_action :initialize_service
      before_action :set_organization

      # POST /phcdevworks_accounts_stytch/b2b/:organization_slug/magic_links/send
      def send_magic_link
        result = @service.send_magic_link(
          email: params[:email],
          organization_id: @organization_id,
          organization_slug: params[:organization_slug]
        )
        render json: result.to_h, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        render json: { error: e.to_h }, status: e.status_code
      end

      # POST /phcdevworks_accounts_stytch/b2b/:organization_slug/magic_links/authenticate
      def authenticate_magic_link
        result = @service.authenticate_magic_link(
          token: params[:token]
        )
        render json: result.to_h, status: :ok
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        render json: { error: e.to_h }, status: e.status_code
      end

      private

      def initialize_service
        @service = PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService.new
      end

      def set_organization
        @organization_id = find_organization_id(params[:organization_slug])
        unless @organization_id
          render json: { error: "Organization not found" }, status: :not_found
        end
      end

      def find_organization_id(slug)
        # Replace this with actual logic to retrieve the organization_id using the slug.
        organization = Organization.find_by(slug: slug)
        organization&.organization_id
      end
    end
  end
end
