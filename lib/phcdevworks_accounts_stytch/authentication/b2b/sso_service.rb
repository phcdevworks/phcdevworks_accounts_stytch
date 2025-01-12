module PhcdevworksAccountsStytch
  module Authentication
    module B2b
      class SsoService < BaseService
        def initialize
          super(type: :b2b)
        end

        def authenticate_sso(sso_token:)
          handle_request do
            client.sso.authenticate(sso_token: sso_token)
          end
        end
      end
    end
  end
end
