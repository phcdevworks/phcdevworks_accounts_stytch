# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PhcdevworksAccountsStytch::B2b::MagicLinksController', type: :routing do
  describe 'routing for B2B' do
    # GET routes
    it 'routes GET /b2b/magic_links/invite to b2b/magic_links#invite' do
      expect(get: '/b2b/magic_links/invite').to route_to('phcdevworks_accounts_stytch/b2b/magic_links#invite')
    end

    it 'routes GET /b2b/magic_links/authenticate to b2b/magic_links#authenticate' do
      expect(get: '/b2b/magic_links/authenticate').to route_to('phcdevworks_accounts_stytch/b2b/magic_links#authenticate')
    end

    it 'routes GET /b2b/magic_links/login to b2b/magic_links#login_or_signup' do
      expect(get: '/b2b/magic_links/login').to route_to('phcdevworks_accounts_stytch/b2b/magic_links#login_or_signup')
    end

    it 'routes GET /b2b/magic_links/signup to b2b/magic_links#login_or_signup' do
      expect(get: '/b2b/magic_links/signup').to route_to('phcdevworks_accounts_stytch/b2b/magic_links#login_or_signup')
    end

    # POST routes
    it 'routes POST /b2b/magic_links/process_invite to b2b/magic_links#process_invite' do
      expect(post: '/b2b/magic_links/process_invite').to route_to('phcdevworks_accounts_stytch/b2b/magic_links#process_invite')
    end

    it 'routes POST /b2b/magic_links/process_authenticate to b2b/magic_links#process_authenticate' do
      expect(post: '/b2b/magic_links/process_authenticate').to route_to('phcdevworks_accounts_stytch/b2b/magic_links#process_authenticate')
    end

    it 'routes POST /b2b/magic_links/process_login_or_signup to b2b/magic_links#process_login_or_signup' do
      expect(post: '/b2b/magic_links/process_login_or_signup').to route_to('phcdevworks_accounts_stytch/b2b/magic_links#process_login_or_signup')
    end
  end
end
