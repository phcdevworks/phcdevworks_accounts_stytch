# frozen_string_literal: true

RSpec.describe PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService, type: :service do
  let(:client) { instance_double(StytchB2B::Client) }
  let(:email) { 'user@example.com' }
  let(:organization_id) { 'org_123' }
  let(:session_token) { 'some_session_token' }
  let(:magic_links_token) { 'some_valid_token' }
  let(:service) { described_class.new }

  before do
    magic_links_email = instance_double(StytchB2B::MagicLinks::Email)
    allow(client).to receive(:magic_links).and_return(instance_double(StytchB2B::MagicLinks, email: magic_links_email))
    allow(PhcdevworksAccountsStytch::Stytch::Client).to receive(:b2b_client).and_return(client)
  end

  describe '#process_login_or_signup' do
    context 'when login or signup is successful' do
      it 'returns the response' do
        response = { status_code: 200, 'user_id' => 'user_123' }
        allow_successful_login_or_signup(response)

        expect(service.process_login_or_signup(email, organization_id)).to eq(response)
      end
    end

    context 'when login or signup fails' do
      it 'raises a custom error' do
        allow_failed_login_or_signup

        expect do
          service.process_login_or_signup(email, organization_id)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error,
                           'Stytch Error (Status Code: 400) - Code: some_error_code - Message: Login error')
      end
    end
  end

  describe '#process_invite' do
    context 'when invite is successful' do
      it 'returns the response' do
        response = { status_code: 200 }
        allow_successful_invite(response)

        expect(service.process_invite(email, organization_id, session_token)).to eq(response)
      end
    end

    context 'when invite fails' do
      it 'raises a custom error' do
        allow_failed_invite

        expect do
          service.process_invite(email, organization_id, session_token)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error,
                           'Stytch Error (Status Code: 400) - Code: invite_error - Message: Invite error')
      end
    end
  end

  describe '#process_authenticate' do
    context 'when authentication is successful' do
      it 'returns the response' do
        response = { status_code: 200, 'user_id' => 'user_123' }
        allow_successful_authentication(response)

        expect(service.process_authenticate(magic_links_token)).to eq(response)
      end
    end

    context 'when authentication fails' do
      it 'raises a custom error' do
        allow_failed_authentication

        expect do
          service.process_authenticate(magic_links_token)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error,
                           'Stytch Error (Status Code: 400) - Code: auth_error - Message: Authentication error')
      end
    end
  end

  private

  def allow_successful_login_or_signup(response)
    allow(client.magic_links.email).to receive(:login_or_signup)
      .with(organization_id: organization_id, email_address: email)
      .and_return(response)
  end

  def allow_failed_login_or_signup
    response = { status_code: 400, error_code: 'some_error_code', error_message: 'Login error' }
    allow(client.magic_links.email).to receive(:login_or_signup)
      .with(organization_id: organization_id, email_address: email)
      .and_return(response)
  end

  def allow_successful_invite(response)
    allow(client.magic_links.email).to receive(:invite)
      .with(
        organization_id: organization_id,
        email_address: email,
        method_options: instance_of(PhcdevworksAccountsStytch::Stytch::MethodOptions)
      )
      .and_return(response)
  end

  def allow_failed_invite
    response = { status_code: 400, error_code: 'invite_error', error_message: 'Invite error' }
    allow(client.magic_links.email).to receive(:invite)
      .with(
        organization_id: organization_id,
        email_address: email,
        method_options: instance_of(PhcdevworksAccountsStytch::Stytch::MethodOptions)
      )
      .and_return(response)
  end

  def allow_successful_authentication(response)
    allow(client.magic_links).to receive(:authenticate)
      .with(magic_links_token: magic_links_token)
      .and_return(response)
  end

  def allow_failed_authentication
    response = { status_code: 400, error_code: 'auth_error', error_message: 'Authentication error' }
    allow(client.magic_links).to receive(:authenticate)
      .with(magic_links_token: magic_links_token)
      .and_return(response)
  end
end
