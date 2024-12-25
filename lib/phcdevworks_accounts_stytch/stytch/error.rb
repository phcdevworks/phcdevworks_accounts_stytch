module PhcdevworksAccountsStytch
  module Stytch
    class Error < StandardError
      attr_reader :status_code, :error_code, :error_message

      def initialize(status_code:, error_code:, error_message:)
        @status_code = status_code
        @error_code = error_code
        @error_message = error_message
        super("#{error_code}: #{error_message}")
      end

      def to_h
        {
          status: status_code,
          error_code: error_code,
          error_message: error_message
        }
      end
    end
  end
end
