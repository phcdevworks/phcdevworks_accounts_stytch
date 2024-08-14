# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2c::MagicLinksController, type: :routing do
  describe 'routing' do
    it 'routes to #login_or_create' do
      expect(post: '/b2c/magic_links/login_or_create')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#login_or_create')
    end

    it 'routes to #send_magic_link' do
      expect(post: '/b2c/magic_links/send')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#send_magic_link')
    end

    it 'routes to #invite' do
      expect(post: '/b2c/magic_links/invite')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#invite')
    end

    it 'routes to #revoke_invite' do
      expect(post: '/b2c/magic_links/revoke_invite')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#revoke_invite')
    end

    it 'routes to #authenticate' do
      expect(post: '/b2c/magic_links/authenticate')
        .to route_to('phcdevworks_accounts_stytch/b2c/magic_links#authenticate')
    end
  end
end
