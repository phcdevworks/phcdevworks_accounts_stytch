# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PhcdevworksAccountsStytch::B2b Passwords Routing', type: :routing do
  let(:organization_slug) { 'example-org' }

  # PasswordsController routes
  it 'routes GET /b2b/passwords/reset/start/:organization_slug to b2b/passwords#reset_start' do
    expect(get: "/b2b/passwords/reset/start/#{organization_slug}")
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'reset_start',
        organization_slug: organization_slug
      )
  end

  it 'routes POST /b2b/passwords/reset/start/:organization_slug to b2b/passwords#process_reset_start' do
    expect(post: "/b2b/passwords/reset/start/#{organization_slug}")
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'process_reset_start',
        organization_slug: organization_slug
      )
  end

  it 'routes GET /b2b/passwords/reset/:organization_slug to b2b/passwords#reset_password' do
    expect(get: "/b2b/passwords/reset/#{organization_slug}")
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'reset_password',
        organization_slug: organization_slug
      )
  end

  it 'routes POST /b2b/passwords/reset/:organization_slug to b2b/passwords#process_reset_password' do
    expect(post: "/b2b/passwords/reset/#{organization_slug}")
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'process_reset_password',
        organization_slug: organization_slug
      )
  end

  it 'routes GET /b2b/passwords/reset/existing/:organization_slug to b2b/passwords#reset_existing_password' do
    expect(get: "/b2b/passwords/reset/existing/#{organization_slug}")
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'reset_existing_password',
        organization_slug: organization_slug
      )
  end

  it 'routes POST /b2b/passwords/reset/existing/:organization_slug to b2b/passwords#process_reset_existing_password' do
    expect(post: "/b2b/passwords/reset/existing/#{organization_slug}")
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'process_reset_existing_password',
        organization_slug: organization_slug
      )
  end

  it 'routes GET /b2b/passwords/reset/session/:organization_slug to b2b/passwords#reset_with_session' do
    expect(get: "/b2b/passwords/reset/session/#{organization_slug}")
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'reset_with_session',
        organization_slug: organization_slug
      )
  end

  it 'routes POST /b2b/passwords/reset/session/:organization_slug to b2b/passwords#process_reset_with_session' do
    expect(post: "/b2b/passwords/reset/session/#{organization_slug}")
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'process_reset_with_session',
        organization_slug: organization_slug
      )
  end
end
