# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    class MethodOptions
      attr_reader :options

      # Initialize the method options
      def initialize(options = {})
        @options = options
      end

      # Convert the options to headers
      def to_headers
        headers = {}
        if (authorization = options[:authorization]) && authorization[:session_token]
          headers['Authorization'] = "Bearer #{authorization[:session_token]}"
        end
        headers
      end
    end
  end
end
