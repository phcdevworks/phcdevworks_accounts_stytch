module PhcdevworksAccountsStytch
  module Stytch
    class Client
      def self.instance(type)
        @clients ||= {}
        @clients[type] ||= create_client(type)
      end

      def self.create_client(type)
        case type
        when :b2b
          StytchB2B::Client.new(
            project_id: Rails.application.credentials.dig(:stytch, :b2b, :project_id),
            secret: Rails.application.credentials.dig(:stytch, :b2b, :secret)
          )
        when :b2c
          ::Stytch::Client.new(
            project_id: Rails.application.credentials.dig(:stytch, :b2c, :project_id),
            secret: Rails.application.credentials.dig(:stytch, :b2c, :secret)
          )
        else
          raise ArgumentError, "Invalid client type"
        end
      end
    end
  end
end
