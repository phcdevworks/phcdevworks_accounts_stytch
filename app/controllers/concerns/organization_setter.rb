# frozen_string_literal: true

module OrganizationSetter
  extend ActiveSupport::Concern

  # Set organization before action
  included do
    before_action :set_organization
  end

  private

  # Set organization based on the slug
  def set_organization
    slug = params[:organization_slug]
    if slug.blank?
      handle_missing_params_error('Organization slug is required')
      return
    end

    @organization_id = fetch_organization_id(slug)
  end

  # Fetch organization ID based on slug
  def fetch_organization_id(slug)
    organization_service.find_organization_id_by_slug(slug)
  rescue PhcdevworksAccountsStytch::Stytch::Error => e
    handle_stytch_error(e)
  rescue StandardError => e
    handle_standard_error(e)
  end

  # Handle Stytch-specific errors
  def handle_stytch_error(error)
    Rails.logger.error("Stytch Error: #{error.message} (Code: #{error.error_code}, Status: #{error.status_code})")
    render json: {
      error: "Stytch Error - #{error.error_message}",
      code: error.error_code,
      details: error.to_h
    }, status: error.status_code
  end

  # Handle unexpected errors
  def handle_standard_error(error)
    Rails.logger.error("Standard Error: #{error.message}")
    render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
  end

  # Handle missing parameters errors
  def handle_missing_params_error(message)
    Rails.logger.error("Missing Params Error: #{message}")
    render json: { error: message }, status: :unprocessable_entity
  end

  # Organization service
  def organization_service
    @organization_service ||= PhcdevworksAccountsStytch::Stytch::Organization.new
  end
end
