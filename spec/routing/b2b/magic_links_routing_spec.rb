# frozen_string_literal: true

RSpec.describe 'PhcdevworksAccountsStytch::B2b::MagicLinksController', type: :routing do
  describe 'routing for B2B' do
    let(:organization_slug) { 'example-org' }

    # GET routes
    it 'routes GET /b2b/magic_links/invite/:organization_slug to b2b/magic_links#invite' do
      expect(get: "/b2b/magic_links/invite/#{organization_slug}")
        .to route_to(
          controller: 'phcdevworks_accounts_stytch/b2b/magic_links',
          action: 'invite',
          organization_slug: organization_slug
        )
    end

    it 'routes GET /b2b/magic_links/authenticate/:organization_slug to b2b/magic_links#authenticate' do
      expect(get: "/b2b/magic_links/authenticate/#{organization_slug}")
        .to route_to(
          controller: 'phcdevworks_accounts_stytch/b2b/magic_links',
          action: 'authenticate',
          organization_slug: organization_slug
        )
    end

    it 'routes GET /b2b/magic_links/login/:organization_slug to b2b/magic_links#login_or_signup' do
      expect(get: "/b2b/magic_links/login/#{organization_slug}")
        .to route_to(
          controller: 'phcdevworks_accounts_stytch/b2b/magic_links',
          action: 'login_or_signup',
          organization_slug: organization_slug
        )
    end

    it 'routes GET /b2b/magic_links/signup/:organization_slug to b2b/magic_links#login_or_signup' do
      expect(get: "/b2b/magic_links/signup/#{organization_slug}")
        .to route_to(
          controller: 'phcdevworks_accounts_stytch/b2b/magic_links',
          action: 'login_or_signup',
          organization_slug: organization_slug
        )
    end

    # POST routes
    it 'routes POST /b2b/magic_links/process_invite/:organization_slug to b2b/magic_links#process_invite' do
      expect(post: "/b2b/magic_links/process_invite/#{organization_slug}")
        .to route_to(
          controller: 'phcdevworks_accounts_stytch/b2b/magic_links',
          action: 'process_invite',
          organization_slug: organization_slug
        )
    end

    it 'routes POST /b2b/magic_links/process_authenticate/:organization_slug to b2b/magic_links#process_authenticate' do
      expect(post: "/b2b/magic_links/process_authenticate/#{organization_slug}")
        .to route_to(
          controller: 'phcdevworks_accounts_stytch/b2b/magic_links',
          action: 'process_authenticate',
          organization_slug: organization_slug
        )
    end

    it 'routes POST /b2b/magic_links/process_login_or_signup/:organization_slug to b2b/magic_links#process_login_or_signup' do
      expect(post: "/b2b/magic_links/process_login_or_signup/#{organization_slug}")
        .to route_to(
          controller: 'phcdevworks_accounts_stytch/b2b/magic_links',
          action: 'process_login_or_signup',
          organization_slug: organization_slug
        )
    end
  end
end
