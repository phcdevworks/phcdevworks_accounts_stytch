# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    class Error < StandardError
      attr_reader :status_code, :error_code, :error_message

      # Initialize the error
      def initialize(status_code: nil, error_code: nil, error_message: nil)
        @status_code = status_code
        @error_code = error_code
        @error_message = error_message unless error_message.nil?
        super(build_message)
      end

      private

      # Build the error message
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
