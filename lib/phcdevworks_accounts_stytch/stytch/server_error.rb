# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    class ServerError < PhcdevworksAccountsStytch::Stytch::Error
      attr_reader :details

      # Initialize the error.
      def initialize(message = 'Unexpected server error', status_code = 500, details = {}, original_error: nil)
        @details = details
        @original_error = original_error

        # If an original error from the Stytch gem exists, extract its attributes
        if original_error.is_a?(Stytch::Error)
          super(
            status_code: original_error.status_code || status_code,
            error_code: original_error.error_code || 'server_error',
            error_message: original_error.message || message,
            cause: original_error
          )
        else
          super(
            status_code: status_code,
            error_code: 'server_error',
            error_message: message,
            cause: original_error
          )
        end

        log_error
      end

      # Serialize the error to a hash
      def to_h
        base_hash = super
        base_hash[:details] = @details if @details.any?
        base_hash
      end

      # Serialize the error to JSON
      def to_json(*_args)
        to_h.to_json
      end

      private

      # Log the error
      def log_error
        Rails.logger.error("ServerError: #{message} (Status Code: #{status_code}, Details: #{details})") if defined?(Rails)
      end
    end
  end
end
