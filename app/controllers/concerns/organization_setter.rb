# frozen_string_literal: true

module OrganizationSetter
  extend ActiveSupport::Concern
  def set_organization
    organization_service = PhcdevworksAccountsStytch::Stytch::Organization.new
    @organization_id = organization_service.find_organization_id_by_slug(params[:organization_slug])
  rescue PhcdevworksAccountsStytch::Stytch::Error => e
    handle_missing_params_error(e.message)
  end
end
