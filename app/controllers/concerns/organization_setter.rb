# frozen_string_literal: true

module OrganizationSetter
  extend ActiveSupport::Concern

  included do
    before_action :set_organization
  end

  private

  def set_organization
    slug = params[:organization_slug]
    if slug.blank?
      handle_missing_params_error('Organization slug is required')
      return
    end

    begin
      @organization_id = organization_service.find_organization_id_by_slug(slug)
    rescue PhcdevworksAccountsStytch::Stytch::Error => e
      handle_missing_params_error("Stytch Error - Message: #{e.error_message}")
    rescue StandardError => e
      handle_missing_params_error(e.message)
    end
  end

  def organization_service
    @organization_service ||= PhcdevworksAccountsStytch::Stytch::Organization.new
  end
end
