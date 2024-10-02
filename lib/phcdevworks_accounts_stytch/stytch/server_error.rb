# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    class ServerError < StandardError
      attr_reader :status_code

      # Initialize the error.
      def initialize(message = 'Unexpected server error', status_code = 500)
        super(message)
        @status_code = status_code
      end
    end
  end
end
