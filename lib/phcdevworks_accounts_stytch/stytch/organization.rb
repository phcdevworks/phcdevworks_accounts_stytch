# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    class Organization
      def initialize(client: PhcdevworksAccountsStytch::Stytch::Client.b2b_client)
        @client = client
      end

      # Finds the organization by its slug and returns the organization ID
      def find_organization_id_by_slug(slug)
        response = @client.organizations.list
        organization = response['organizations'].find { |org| org['organization_slug'] == slug }

        if organization
          organization['organization_id']
        else
          raise PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: 404,
            error_message: "Organization with slug '#{slug}' not found."
          )
        end
      end
    end
  end
end
