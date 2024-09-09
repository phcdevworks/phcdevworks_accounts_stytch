# frozen_string_literal: true

RSpec.describe 'PhcdevworksAccountsStytch::B2c Routing', type: :routing do
  describe 'routing for B2C' do
    # MagicLinksController GET routes
    it 'routes GET /b2c/magic_links/invite to b2c/magic_links#invite' do
      expect(get: '/b2c/magic_links/invite')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#invite')
    end

    it 'routes GET /b2c/magic_links/login to b2c/magic_links#login_or_signup' do
      expect(get: '/b2c/magic_links/login')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#login_or_signup')
    end

    it 'routes GET /b2c/magic_links/signup to b2c/magic_links#login_or_signup' do
      expect(get: '/b2c/magic_links/signup')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#login_or_signup')
    end

    # MagicLinksController POST routes
    it 'routes POST /b2c/magic_links/process_invite to b2c/magic_links#process_invite' do
      expect(post: '/b2c/magic_links/process_invite')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#process_invite')
    end

    it 'routes POST /b2c/magic_links/process_revoke_invite to b2c/magic_links#process_revoke_invite' do
      expect(post: '/b2c/magic_links/process_revoke_invite')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#process_revoke_invite')
    end

    it 'routes POST /b2c/magic_links/process_login_or_signup to b2c/magic_links#process_login_or_signup' do
      expect(post: '/b2c/magic_links/process_login_or_signup')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#process_login_or_signup')
    end

    # AuthenticateController routes
    it 'routes GET /b2c/authenticate to b2c/authenticate#authenticate' do
      expect(get: '/b2c/authenticate')
        .to route_to('phcdevworks_accounts_stytch/b2c/authenticate#authenticate')
    end

    it 'routes POST /b2c/process_authenticate to b2c/authenticate#process_authenticate' do
      expect(post: '/b2c/process_authenticate')
        .to route_to('phcdevworks_accounts_stytch/b2c/authenticate#process_authenticate')
    end
  end
end
