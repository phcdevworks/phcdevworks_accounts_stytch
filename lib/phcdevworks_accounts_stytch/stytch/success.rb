module PhcdevworksAccountsStytch
  module Stytch
    class Success
      attr_reader :status_code, :message, :data

      def initialize(status_code:, message:, data: {})
        @status_code = status_code
        @message = message
        @data = data
      end

      def to_h
        {
          status_code: status_code,
          message: message,
          data: data
        }
      end
    end
  end
end
