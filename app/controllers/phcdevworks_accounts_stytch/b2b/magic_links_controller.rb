# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2b
    class MagicLinksController < ApplicationController
      def invite
        service = PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService.new
        result = service.invite(params[:email], params[:organization_id])

        if result
          render json: { message: 'Invite sent successfully.' }, status: :ok
        else
          render json: { error: 'Failed to send invite.' }, status: :unprocessable_entity
        end
      end

      def authenticate
        service = PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService.new
        result = service.authenticate(params[:token])

        if result
          render json: { message: 'Authentication successful.', user_id: result['user_id'] }, status: :ok
        else
          render json: { error: 'Failed to authenticate.' }, status: :unprocessable_entity
        end
      end
    end
  end
end
