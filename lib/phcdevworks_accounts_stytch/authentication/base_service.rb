module PhcdevworksAccountsStytch
  module Authentication
    class BaseService
      attr_reader :client

      def initialize(type: :b2b)
        @client = PhcdevworksAccountsStytch::Stytch::Client.instance(type)
      end

      def handle_request(&block)
        response = yield
        PhcdevworksAccountsStytch::Stytch::Response.handle_response(response)
      rescue PhcdevworksAccountsStytch::Stytch::Error => e
        handle_error(e)
      end

      private

      def handle_error(error)
        # Custom error handling logic
        Rails.logger.error("[Stytch Error] #{error.to_h}")
        raise error
      end
    end
  end
end
