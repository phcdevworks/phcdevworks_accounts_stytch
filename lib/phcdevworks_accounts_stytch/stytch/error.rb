# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    # Custom error class for handling errors from the Stytch API
    class Error < StandardError
      attr_reader :status_code, :error_code, :error_message

      def initialize(status_code: nil, error_code: nil, error_message: nil)
        @status_code = status_code
        @error_code = error_code
        @error_message = error_message || 'An error occurred with Stytch'
        super(build_message)
      end

      private

      def build_message
        message = 'Stytch Error'
        message += " (Status Code: #{@status_code})" if @status_code
        message += " - Code: #{@error_code}" if @error_code
        message += " - Message: #{@error_message}" if @error_message
        message
      end
    end
  end
end
