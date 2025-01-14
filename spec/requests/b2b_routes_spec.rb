require 'rails_helper'

RSpec.describe "PhcdevworksAccountsStytch::B2B Routes", type: :routing do
  describe "authentication routes" do
    it "routes POST /phcdevworks_accounts_stytch/b2b/authenticate to authenticate#create" do
      expect(post: "/phcdevworks_accounts_stytch/b2b/authenticate").to route_to(
        controller: "phcdevworks_accounts_stytch/b2b/authenticate",
        action: "create"
      )
    end

    it "routes DELETE /phcdevworks_accounts_stytch/b2b/logout to authenticate#destroy" do
      expect(delete: "/phcdevworks_accounts_stytch/b2b/logout").to route_to(
        controller: "phcdevworks_accounts_stytch/b2b/authenticate",
        action: "destroy"
      )
    end
  end

  describe "organization-scoped routes" do
    let(:org_slug) { "test-org" }
    let(:base_path) { "/phcdevworks_accounts_stytch/b2b/#{org_slug}" }

    describe "magic links routes" do
      it "routes POST /:organization_slug/magic_links/send to magic_links#send_magic_link" do
        expect(post: "#{base_path}/magic_links/send").to route_to(
          controller: "phcdevworks_accounts_stytch/b2b/magic_links",
          action: "send_magic_link",
          organization_slug: org_slug
        )
      end

      it "routes POST /:organization_slug/magic_links/authenticate to magic_links#authenticate_magic_link" do
        expect(post: "#{base_path}/magic_links/authenticate").to route_to(
          controller: "phcdevworks_accounts_stytch/b2b/magic_links",
          action: "authenticate_magic_link",
          organization_slug: org_slug
        )
      end

      it "routes GET /:organization_slug/magic_links/login to magic_links#login" do
        expect(get: "#{base_path}/magic_links/login").to route_to(
          controller: "phcdevworks_accounts_stytch/b2b/magic_links",
          action: "login",
          organization_slug: org_slug
        )
      end

      it "routes GET /:organization_slug/magic_links/signup to magic_links#signup" do
        expect(get: "#{base_path}/magic_links/signup").to route_to(
          controller: "phcdevworks_accounts_stytch/b2b/magic_links",
          action: "signup",
          organization_slug: org_slug
        )
      end
    end

    describe "passwords routes" do
      it "routes POST /:organization_slug/passwords/create to passwords#create" do
        expect(post: "#{base_path}/passwords/create").to route_to(
          controller: "phcdevworks_accounts_stytch/b2b/passwords",
          action: "create",
          organization_slug: org_slug
        )
      end

      it "routes POST /:organization_slug/passwords/authenticate to passwords#authenticate" do
        expect(post: "#{base_path}/passwords/authenticate").to route_to(
          controller: "phcdevworks_accounts_stytch/b2b/passwords",
          action: "authenticate",
          organization_slug: org_slug
        )
      end

      it "routes POST /:organization_slug/passwords/reset to passwords#reset" do
        expect(post: "#{base_path}/passwords/reset").to route_to(
          controller: "phcdevworks_accounts_stytch/b2b/passwords",
          action: "reset",
          organization_slug: org_slug
        )
      end
    end

    describe "SSO routes" do
      it "routes POST /:organization_slug/sso/authenticate to sso#authenticate" do
        expect(post: "#{base_path}/sso/authenticate").to route_to(
          controller: "phcdevworks_accounts_stytch/b2b/sso",
          action: "authenticate",
          organization_slug: org_slug
        )
      end
    end
  end
end
