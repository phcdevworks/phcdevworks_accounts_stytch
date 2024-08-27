# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    module Response
      def self.handle_response(response)
        # Ensure that the response is a hash
        response = response.is_a?(Hash) ? response : JSON.parse(response)

        # Extract the status code from the response
        status_code = response['status_code'] || 500

        if success_status?(status_code)
          build_success_response(status_code, response)
        else
          build_error_response(response, status_code)
        end
      end

      def self.success_status?(status_code)
        status_code.between?(200, 299)
      end

      def self.build_success_response(status_code, response)
        PhcdevworksAccountsStytch::Stytch::Success.new(
          status_code: status_code,
          message: "Successfully processed request with status code #{status_code}.",
          data: response
        )
      end

      def self.build_error_response(response, status_code)
        # Extract relevant error details from the response
        error_code = response['error_type'] || 'unknown_error'
        error_message = response['error_message'] || 'An unknown error occurred'

        # Log the error for debugging
        Rails.logger.error "Stytch API error: #{response.inspect}"

        # Raise a custom error with the extracted details
        raise PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: status_code,
          error_code: error_code,
          error_message: error_message
        )
      end
    end
  end
end
