# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    class Success
      attr_reader :status_code, :message, :data

      def initialize(status_code:, message: 'Action completed successfully.', data: {})
        @status_code = status_code
        @message = message
        @data = data
      end

      def success?
        true
      end
    end
  end
end
