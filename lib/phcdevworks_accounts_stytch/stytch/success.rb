# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    class Success
      attr_reader :status_code, :message, :data

      # Initialize the success response.
      def initialize(status_code:, message: 'Action completed successfully.', data: {})
        validate_status_code(status_code)
        @status_code = status_code
        @message = message
        @data = data
        log_success
      end

      # Check if the response is successful.
      def success?
        true
      end

      # Serialize the success response to a hash.
      def to_h
        {
          status_code: @status_code,
          message: @message,
          data: @data
        }
      end

      # Serialize the success response to JSON.
      def to_json(*_args)
        to_h.to_json
      end

      private

      # Validate that the status code is within the success range.
      def validate_status_code(status_code)
        unless status_code.between?(200, 299)
          raise ArgumentError, "Invalid status code for success: #{status_code}"
        end
      end

      # Log the success response.
      def log_success
        Rails.logger.info("Success: #{@message} (Status Code: #{@status_code}, Data: #{@data})") if defined?(Rails)
      end
    end
  end
end
