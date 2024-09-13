# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2c::MagicLinksController, type: :routing do
  routes { PhcdevworksAccountsStytch::Engine.routes }

  it 'routes GET /b2c/magic_links/invite to b2c/magic_links#invite' do
    expect(get: '/b2c/magic_links/invite').to route_to(
      controller: 'phcdevworks_accounts_stytch/b2c/magic_links',
      action: 'invite'
    )
  end

  it 'routes GET /b2c/magic_links/login to b2c/magic_links#login_or_signup' do
    expect(get: '/b2c/magic_links/login').to route_to(
      controller: 'phcdevworks_accounts_stytch/b2c/magic_links',
      action: 'login_or_signup'
    )
  end

  it 'routes GET /b2c/magic_links/signup to b2c/magic_links#login_or_signup' do
    expect(get: '/b2c/magic_links/signup').to route_to(
      controller: 'phcdevworks_accounts_stytch/b2c/magic_links',
      action: 'login_or_signup'
    )
  end

  it 'routes POST /b2c/magic_links/process_invite to b2c/magic_links#process_invite' do
    expect(post: '/b2c/magic_links/process_invite').to route_to(
      controller: 'phcdevworks_accounts_stytch/b2c/magic_links',
      action: 'process_invite'
    )
  end

  it 'routes POST /b2c/magic_links/process_revoke_invite to b2c/magic_links#process_revoke_invite' do
    expect(post: '/b2c/magic_links/process_revoke_invite').to route_to(
      controller: 'phcdevworks_accounts_stytch/b2c/magic_links',
      action: 'process_revoke_invite'
    )
  end

  it 'routes POST /b2c/magic_links/process_login_or_signup to b2c/magic_links#process_login_or_signup' do
    expect(post: '/b2c/magic_links/process_login_or_signup').to route_to(
      controller: 'phcdevworks_accounts_stytch/b2c/magic_links',
      action: 'process_login_or_signup'
    )
  end
end
