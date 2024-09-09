# frozen_string_literal: true

RSpec.describe 'PhcdevworksAccountsStytch::B2b Routing', type: :routing do
  let(:organization_slug) { 'example-org' }

  # MagicLinksController routes
  it 'routes GET /b2b/magic_links/invite/:organization_slug to b2b/magic_links#invite' do
    expect(get: "/b2b/magic_links/invite/#{organization_slug}")
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/magic_links',
        action: 'invite',
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

  it 'routes POST /b2b/magic_links/process_invite/:organization_slug to b2b/magic_links#process_invite' do
    expect(post: "/b2b/magic_links/process_invite/#{organization_slug}")
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/magic_links',
        action: 'process_invite',
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

  # PasswordsController routes
  it 'routes GET /b2b/passwords/reset/start to b2b/passwords#reset_start_form' do
    expect(get: '/b2b/passwords/reset/start')
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'reset_start_form'
      )
  end

  it 'routes POST /b2b/passwords/reset/start to b2b/passwords#reset_start' do
    expect(post: '/b2b/passwords/reset/start')
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'reset_start'
      )
  end

  it 'routes GET /b2b/passwords/reset to b2b/passwords#reset_form' do
    expect(get: '/b2b/passwords/reset')
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'reset_form'
      )
  end

  it 'routes POST /b2b/passwords/reset to b2b/passwords#reset_process' do
    expect(post: '/b2b/passwords/reset')
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'reset_process'
      )
  end

  it 'routes GET /b2b/passwords/reset/existing to b2b/passwords#reset_existing_password_form' do
    expect(get: '/b2b/passwords/reset/existing')
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'reset_existing_password_form'
      )
  end

  it 'routes POST /b2b/passwords/reset/existing to b2b/passwords#reset_existing_password' do
    expect(post: '/b2b/passwords/reset/existing')
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'reset_existing_password'
      )
  end

  it 'routes GET /b2b/passwords/reset/session to b2b/passwords#reset_with_session_form' do
    expect(get: '/b2b/passwords/reset/session')
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'reset_with_session_form'
      )
  end

  it 'routes POST /b2b/passwords/reset/session to b2b/passwords#reset_with_session' do
    expect(post: '/b2b/passwords/reset/session')
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/passwords',
        action: 'reset_with_session'
      )
  end

  # AuthenticateController routes
  it 'routes GET /b2b/authenticate to b2b/authenticate#authenticate' do
    expect(get: '/b2b/authenticate')
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/authenticate',
        action: 'authenticate'
      )
  end

  it 'routes POST /b2b/process_authenticate to b2b/authenticate#process_authenticate' do
    expect(post: '/b2b/process_authenticate')
      .to route_to(
        controller: 'phcdevworks_accounts_stytch/b2b/authenticate',
        action: 'process_authenticate'
      )
  end
end
