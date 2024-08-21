# frozen_string_literal: true

RSpec.describe 'PhcdevworksAccountsStytch::B2c::MagicLinksController', type: :routing do
  describe 'routing for B2C' do
    # GET routes
    it 'routes GET /b2c/magic_links/invite to b2c/magic_links#invite' do
      expect(get: '/b2c/magic_links/invite')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#invite')
    end

    it 'routes GET /b2c/magic_links/revoke_invite to b2c/magic_links#invite' do
      expect(get: '/b2c/magic_links/revoke_invite')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#invite')
    end

    it 'routes GET /b2c/magic_links/authenticate to b2c/magic_links#authenticate' do
      expect(get: '/b2c/magic_links/authenticate')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#authenticate')
    end

    it 'routes GET /b2c/magic_links/login to b2c/magic_links#login_or_signup' do
      expect(get: '/b2c/magic_links/login')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#login_or_signup')
    end

    it 'routes GET /b2c/magic_links/signup to b2c/magic_links#login_or_signup' do
      expect(get: '/b2c/magic_links/signup')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#login_or_signup')
    end

    # POST routes
    it 'routes POST /b2c/magic_links/invite to b2c/magic_links#invite' do
      expect(post: '/b2c/magic_links/invite')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#invite')
    end

    it 'routes POST /b2c/magic_links/authenticate to b2c/magic_links#authenticate' do
      expect(post: '/b2c/magic_links/authenticate')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#authenticate')
    end

    it 'routes POST /b2c/magic_links/login_or_create to b2c/magic_links#login_or_create' do
      expect(post: '/b2c/magic_links/login_or_create')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#login_or_create')
    end

    it 'routes POST /b2c/magic_links/revoke_invite to b2c/magic_links#revoke_invite' do
      expect(post: '/b2c/magic_links/revoke_invite')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#revoke_invite')
    end

    it 'routes POST /b2c/magic_links/send to b2c/magic_links#send_magic_link' do
      expect(post: '/b2c/magic_links/send')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#send_magic_link')
    end
  end
end
