# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    class Error < StandardError
      attr_reader :status_code, :error_code, :error_message, :cause, :original_error

      # Initialize the error
      def initialize(status_code: 500, error_code: 'unknown_error', error_message: 'An unknown error occurred', cause: nil, original_error: nil)
        @status_code = status_code
        @error_code = error_code
        @error_message = error_message
        @cause = cause
        @original_error = original_error
        log_error
        super(build_message)
      end

      # Wrap a Stytch-specific error
      def self.from_stytch_error(error)
        new(
          status_code: error.respond_to?(:status_code) ? error.status_code : 500,
          error_code: error.respond_to?(:error_code) ? error.error_code : 'stytch_error',
          error_message: error.message,
          original_error: error
        )
      end

      # Serialize the error to a hash
      def to_h
        {
          status_code: @status_code,
          error_code: @error_code,
          error_message: @error_message,
          cause: @cause&.message,
          original_error: original_error_details
        }
      end

      # Serialize the error to JSON
      def to_json(*_args)
        to_h.to_json
      end

      private

      # Extract details from the original error if present
      def original_error_details
        return unless @original_error

        {
          class: @original_error.class.name,
          message: @original_error.message,
          backtrace: @original_error.backtrace&.first(5) # Limit backtrace to the first 5 lines
        }
      end

      # Build the error message
      def build_message
        message = 'Stytch Error'
        message += " (Status Code: #{@status_code})" if @status_code
        message += " - Code: #{@error_code}" if @error_code
        message += " - Message: #{@error_message}" if @error_message
        message += " - Cause: #{@cause.message}" if @cause
        message
      end

      # Log the error
      def log_error
        Rails.logger.error(build_message) if defined?(Rails)
      end
    end
  end
end
