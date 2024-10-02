# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    module Response
      # Handle the response from the Stytch API.
      def self.handle_response(response)
        status_code = response[:http_status_code] || 500
        status_message = response[:status] || default_status_message(status_code)

        if success_status?(status_code)
          build_success_response(status_code, status_message, response)
        else
          build_error_response(response, status_code)
        end
      end

      # Default status message for a given status code.
      def self.default_status_message(status_code)
        status_code == 200 ? 'Success' : 'Error'
      end

      # Default success status code range.
      def self.success_status?(status_code)
        status_code.between?(200, 299)
      end

      # Build a success response.
      def self.build_success_response(status_code, _status_message, response)
        PhcdevworksAccountsStytch::Stytch::Success.new(
          status_code: status_code,
          message: "Successfully invited #{response[:email_address]}.",
          data: response
        )
      end

      # Build an error response.
      def self.build_error_response(response, status_code)
        error_code = response.dig(:stytch_api_error, :error_type) || 'unknown_error'
        error_message = response.dig(:stytch_api_error, :error_message) || 'An unknown error occurred'

        raise PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: status_code,
          error_code: error_code,
          error_message: error_message
        )
      end
    end
  end
end
