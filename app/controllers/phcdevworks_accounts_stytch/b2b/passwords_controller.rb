class PhcdevworksAccountsStytch::B2b::PasswordsController < ApplicationController
  before_action :initialize_service

  # POST /:organization_slug/passwords/create
  def create
    result = @service.handle_request do
      @service.client.passwords.create(
        organization_slug: params[:organization_slug],
        email: params[:email],
        password: params[:password]
      )
    end
    render json: result.to_h, status: :ok
  rescue PhcdevworksAccountsStytch::Stytch::Error => e
    render json: { error: e.to_h }, status: e.status_code
  end

  # POST /:organization_slug/passwords/authenticate
  def authenticate
    result = @service.handle_request do
      @service.client.passwords.authenticate(
        organization_slug: params[:organization_slug],
        email: params[:email],
        password: params[:password]
      )
    end
    render json: result.to_h, status: :ok
  rescue PhcdevworksAccountsStytch::Stytch::Error => e
    render json: { error: e.to_h }, status: e.status_code
  end

  # POST /:organization_slug/passwords/reset
  def reset
    result = @service.handle_request do
      @service.client.passwords.reset(
        organization_slug: params[:organization_slug],
        email: params[:email],
        reset_token: params[:reset_token],
        new_password: params[:new_password]
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
