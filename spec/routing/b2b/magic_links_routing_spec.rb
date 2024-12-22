require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::MagicLinksController, type: :routing do
  describe 'routing' do
    context 'member routes' do
      it 'routes GET /b2b/magic_links/:id/invite to magic_links#invite' do
        expect(get: '/b2b/magic_links/123/invite').to route_to(
          controller: 'phcdevworks_accounts_stytch/b2b/magic_links',
          action: 'invite',
          id: '123'
        )
      end

      it 'routes GET /b2b/magic_links/:id/login to magic_links#login_or_signup' do
        expect(get: '/b2b/magic_links/123/login').to route_to(
          controller: 'phcdevworks_accounts_stytch/b2b/magic_links',
          action: 'login_or_signup',
          id: '123'
        )
      end

      it 'routes GET /b2b/magic_links/:id/signup to magic_links#login_or_signup' do
        expect(get: '/b2b/magic_links/123/signup').to route_to(
          controller: 'phcdevworks_accounts_stytch/b2b/magic_links',
          action: 'login_or_signup',
          id: '123'
        )
      end
    end

    context 'collection routes' do
      it 'routes POST /b2b/magic_links/process_invite to magic_links#process_invite' do
        expect(post: '/b2b/magic_links/process_invite').to route_to(
          controller: 'phcdevworks_accounts_stytch/b2b/magic_links',
          action: 'process_invite'
        )
      end

      it 'routes POST /b2b/magic_links/process_login_or_signup to magic_links#process_login_or_signup' do
        expect(post: '/b2b/magic_links/process_login_or_signup').to route_to(
          controller: 'phcdevworks_accounts_stytch/b2b/magic_links',
          action: 'process_login_or_signup'
        )
      end
    end
  end
end
