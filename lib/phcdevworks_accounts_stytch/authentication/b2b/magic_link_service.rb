module PhcdevworksAccountsStytch
  module Authentication
    module B2b
      class MagicLinkService < BaseService
        include Rails.application.routes.url_helpers

        def send_magic_link(email:, organization_id:, organization_slug:)
          handle_request do
            client.magic_links.email.login_or_create(
              email: email,
              organization_id: organization_id,
              login_magic_link_url: callback_url("login", organization_slug: organization_slug),
              signup_magic_link_url: callback_url("signup", organization_slug: organization_slug),
              user_metadata: { source: "b2b_magic_link" }
            )
          end
        end

        def authenticate_magic_link(token:)
          handle_request do
            client.magic_links.authenticate(magic_links_token: token)
          end
        end

        private

        def callback_url(action, organization_slug:)
          route_name = "phcdevworks_accounts_stytch_b2b_magic_link_#{action}_url"
          send(route_name, organization_slug: organization_slug, host: default_host)
        end

        def default_host
          Rails.application.config.default_url_options[:host] || "http://localhost:3000"
        end
      end
    end
  end
end
