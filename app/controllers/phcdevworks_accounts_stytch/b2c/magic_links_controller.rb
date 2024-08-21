# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module B2c
    class MagicLinksController < ApplicationController
      def login_or_create
        service = PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService.new
        result = service.login_or_create(params[:email])

        if result
          render json: { message: 'Magic link sent or user created successfully.', user_id: result['user_id'] },
                 status: :ok
        else
          render json: { error: 'Failed to send magic link or create user.' }, status: :unprocessable_entity
        end
      end

      def send_magic_link
        service = PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService.new
        result = service.send_magic_link(params[:email])

        if result
          render json: { message: 'Magic link sent successfully.' }, status: :ok
        else
          render json: { error: 'Failed to send magic link.' }, status: :unprocessable_entity
        end
      end

      def invite
        service = PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService.new
        result = service.invite(params[:email], params[:session_token])

        if result
          render json: { message: 'Invite sent successfully.' }, status: :ok
        else
          render json: { error: 'Failed to send invite.' }, status: :unprocessable_entity
        end
      end

      def revoke_invite
        service = PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService.new
        result = service.revoke_invite(params[:email])

        if result
          render json: { message: 'Invite revoked successfully.' }, status: :ok
        else
          render json: { error: 'Failed to revoke invite.' }, status: :unprocessable_entity
        end
      end

      def authenticate
        service = PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService.new
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
