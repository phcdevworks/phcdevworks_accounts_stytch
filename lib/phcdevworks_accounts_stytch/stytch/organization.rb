# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    class Organization
      def initialize
        @client = PhcdevworksAccountsStytch::Stytch::Client.b2b_client
      end

      def find_organization_id_by_slug(slug)
        response = search_organization_by_slug(slug)
        extract_organization_id(response, slug)
      rescue StandardError => e
        handle_error(e)
      end

      private

      def search_organization_by_slug(slug)
        @client.organizations.search(
          query: {
            operator: 'OR',
            operands: [
              { filter_name: 'organization_slugs', filter_value: [slug] }
            ]
          }
        )
      end

      def extract_organization_id(response, slug)
        organizations = response['organizations']
        if organizations&.any?
          organization = organizations.first
          organization['organization_id']
        else
          raise PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: 404,
            error_message: "Organization with slug '#{slug}' not found"
          )
        end
      end

      def handle_error(error)
        raise PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: error.respond_to?(:status_code) ? error.status_code : 500,
          error_message: error.message
        )
      end
    end
  end
end
