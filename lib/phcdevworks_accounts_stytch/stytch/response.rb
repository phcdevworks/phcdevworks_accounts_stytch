# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    module Response
      # Handle the response from the Stytch API
      def self.handle_response(response)
        status_code = response[:http_status_code] || 500
        status_message = response[:status] || default_status_message(status_code)

        if success_status?(status_code)
          build_success_response(status_code, status_message, response)
        else
          build_error_response(response, status_code)
        end
      end

      private

      # Default status message for a given status code
      def self.default_status_message(status_code)
        case status_code
        when 200 then 'Success'
        when 201 then 'Created'
        when 400 then 'Bad Request'
        when 401 then 'Unauthorized'
        when 403 then 'Forbidden'
        when 404 then 'Not Found'
        when 500 then 'Internal Server Error'
        else 'Error'
        end
      end

      # Determine if the status code indicates success
      def self.success_status?(status_code)
        status_code.between?(200, 299)
      end

      # Build a success response
      def self.build_success_response(status_code, status_message, response)
        PhcdevworksAccountsStytch::Stytch::Success.new(
          status_code: status_code,
          message: status_message,
          data: response
        )
      end

      # Build an error response
      def self.build_error_response(response, status_code)
        error_code = response.dig(:stytch_api_error, :error_type) || 'unknown_error'
        error_message = response.dig(:stytch_api_error, :error_message) || 'An unknown error occurred'
        log_error(status_code, error_code, error_message)

        raise PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: status_code,
          error_code: error_code,
          error_message: error_message
        )
      end

      # Log an error
      def self.log_error(status_code, error_code, error_message)
        Rails.logger.error(
          "[Stytch API Error] Status Code: #{status_code}, Error Code: #{error_code}, Message: #{error_message}"
        ) if defined?(Rails)
      end
    end
  end
end
