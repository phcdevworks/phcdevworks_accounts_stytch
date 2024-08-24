# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    module Response
      def self.handle_response(response)
        status_code = extract_status_code(response)
        status_message = determine_status_message(response, status_code)

        if success_status?(status_code)
          build_success_response(status_code, status_message, response)
        else
          handle_error_response(response, status_code)
        end
      end

      def self.extract_status_code(response)
        response[:http_status_code] || 500
      end

      def self.determine_status_message(response, status_code)
        response[:status] || default_status_message(status_code)
      end

      def self.default_status_message(status_code)
        status_code == 200 ? 'Success' : 'Error'
      end

      def self.success_status?(status_code)
        status_code.between?(200, 299)
      end

      def self.build_success_response(status_code, status_message, response)
        PhcdevworksAccountsStytch::Stytch::Success.new(
          status_code: status_code,
          message: status_message,
          data: response
        )
      end

      def self.handle_error_response(response, status_code)
        error_code = response[:"stytch_api_error.error_type"] || 'unknown_error'
        error_message = response[:"stytch_api_error.error_message"] || 'An unknown error occurred'

        raise PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: status_code,
          error_code: error_code,
          error_message: error_message
        )
      end
    end
  end
end
