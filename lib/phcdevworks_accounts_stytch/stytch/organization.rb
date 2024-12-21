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
      rescue ::Stytch::Error => e
        raise PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: e.status_code,
          error_code: 'stytch_error',
          error_message: e.message
        )
      end

      private

      # Search for an organization by slug
      def search_organization_by_slug(slug)
        query = {
          operator: 'OR',
          operands: [
            { filter_name: 'organization_slugs', filter_value: [slug] }
          ]
        }
        begin
          @client.organizations.search(query: query)
        rescue Stytch::Error => e
          raise PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: e.status_code,
            error_code: 'stytch_error',
            error_message: e.message
          )
        end
      end

      # Extract the organization ID from the response
      def extract_organization_id(response, slug)
        organizations = response['organizations'] || []
        organization = organizations.first

        return organization['organization_id'] if organization

        raise PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: 404,
          error_code: 'not_found',
          error_message: "Organization with slug '#{slug}' not found"
        )
      end

      # Handle the error
      def handle_error(error)
        # Wrap errors that don't have a status_code
        wrapped_error = if error.respond_to?(:status_code)
                          error
                        else
                          PhcdevworksAccountsStytch::Stytch::Error.new(
                            status_code: 500,
                            error_code: 'unknown_error',
                            error_message: "Unexpected error: #{error.message}"
                          )
                        end

        log_error(wrapped_error)

        case wrapped_error.status_code
        when 404
          raise PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: 404,
            error_code: 'not_found',
            error_message: 'Organization not found'
          )
        when 403
          raise PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: 403,
            error_code: 'forbidden',
            error_message: 'Forbidden access'
          )
        else
          raise wrapped_error
        end
      end

      # Log the error
      def log_error(error)
        return unless defined?(Rails.logger)

        Rails.logger.error("Error: #{error.message} (Status Code: #{error.status_code})")
      end
    end
  end
end
