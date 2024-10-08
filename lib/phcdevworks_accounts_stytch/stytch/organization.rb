# frozen_string_literal: true

require_relative 'server_error'

module PhcdevworksAccountsStytch
  module Stytch
    class Organization
      # Initialize the client
      def initialize
        @client = PhcdevworksAccountsStytch::Stytch::Client.b2b_client
      end

      # Find an organization by slug
      def find_organization_id_by_slug(slug)
        response = search_organization_by_slug(slug)
        extract_organization_id(response, slug)
      rescue StandardError => e
        handle_error(e)
      end

      private

      # Search for an organization by slug
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

      # Extract the organization ID from the response
      def extract_organization_id(response, slug)
        organizations = response['organizations']
        organization = organizations.first

        if organization
          organization['organization_id']
        else
          raise PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: 404,
            error_message: "Organization with slug '#{slug}' not found"
          )
        end
      end

      # Handle the error
      def handle_error(error)
        error = PhcdevworksAccountsStytch::Stytch::ServerError.new(error.message) unless error.respond_to?(:status_code)

        case error.status_code
        when 404
          raise PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: 404,
            error_message: 'Organization not found'
          )
        when 403
          raise PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: 403,
            error_message: 'Forbidden access'
          )
        else
          raise PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: error.status_code || 500,
            error_message: error.message
          )
        end
      end
    end
  end
end
