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
        add_authorization_header(headers)
        add_custom_headers(headers)
        headers
      end

      # Return headers directly
      alias headers to_headers

      private

      # Add the Authorization header
      def add_authorization_header(headers)
        if options[:authorization].is_a?(Hash)
          session_token = options[:authorization][:session_token]
          headers['Authorization'] = "Bearer #{session_token}" if session_token
        end
      end

      # Add other custom headers
      def add_custom_headers(headers)
        headers['Content-Type'] = options[:content_type] if options[:content_type]
        headers['Accept'] = options[:accept] if options[:accept]
      end
    end
  end
end
