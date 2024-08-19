# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::MagicLinksController, type: :routing do
  describe 'routing' do
    it 'routes to #login_or_signup' do
      expect(post: '/b2b/magic_links/login_or_signup')
        .to route_to('phcdevworks_accounts_stytch/b2b/magic_links#login_or_signup')
    end

    it 'routes to #invite' do
      expect(post: '/b2b/magic_links/invite')
        .to route_to('phcdevworks_accounts_stytch/b2b/magic_links#invite')
    end

    it 'routes to #authenticate' do
      expect(post: '/b2b/magic_links/authenticate')
        .to route_to('phcdevworks_accounts_stytch/b2b/magic_links#authenticate')
    end
  end
end
