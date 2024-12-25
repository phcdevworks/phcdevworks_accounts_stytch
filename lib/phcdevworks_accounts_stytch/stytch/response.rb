module PhcdevworksAccountsStytch
  module Stytch
    class Response
      def self.handle_response(response)
        status_code = response[:http_status_code] || 500
        data = response[:data] || {}
        error = response[:stytch_api_error]

        if success_status?(status_code)
          return Success.new(status_code: status_code, message: "Success", data: data)
        end

        raise Error.new(
          status_code: status_code,
          error_code: error[:error_type],
          error_message: error[:error_message]
        )
      end

      def self.success_status?(status_code)
        status_code.between?(200, 299)
      end
    end
  end
end
