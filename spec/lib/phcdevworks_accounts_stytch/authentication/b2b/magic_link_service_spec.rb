# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService do
  let(:client) { instance_double(StytchB2B::Client) }
  let(:magic_links) { instance_double(StytchB2B::MagicLinks) }
  let(:magic_links_email) { instance_double(StytchB2B::MagicLinks::Email) }
  let(:email) { 'user@example.com' }
  let(:organization_id) { 'org_123' }
  let(:session_token) { 'some_session_token' }
  let(:magic_links_token) { 'some_valid_token' }
  let(:service) { described_class.new }

  before do
    allow(client).to receive(:magic_links).and_return(magic_links)
    allow(magic_links).to receive(:email).and_return(magic_links_email)
    allow(PhcdevworksAccountsStytch::Stytch::Client).to receive(:b2b_client).and_return(client)
  end

  describe '#process_login_or_signup' do
    context 'when login or signup is successful' do
      it 'returns a Success object' do
        response = successful_response
        allow_successful_login_or_signup(response)

        result = service.process_login_or_signup(email, organization_id)

        expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
        expect(result.status_code).to eq(200)
        expect(result.data).to eq(response)
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
      it 'returns a Success object' do
        response = successful_response
        allow_successful_invite(response)

        result = service.process_invite(email, organization_id, session_token)

        expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
        expect(result.status_code).to eq(200)
        expect(result.data).to eq(response)
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
      it 'returns a Success object' do
        response = successful_response
        allow_successful_authentication(response)

        result = service.process_authenticate(magic_links_token)

        expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
        expect(result.status_code).to eq(200)
        expect(result.data).to eq(response)
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

  def successful_response
    {
      http_status_code: 200,
      user_id: 'user_123'
    }
  end

  def allow_successful_login_or_signup(response)
    allow(magic_links_email).to receive(:login_or_signup)
      .with(organization_id: organization_id, email_address: email)
      .and_return(response)
  end

  def allow_failed_login_or_signup
    response = {
      http_status_code: 400,
      stytch_api_error: {
        error_type: 'some_error_code',
        error_message: 'Login error'
      }
    }
    allow(magic_links_email).to receive(:login_or_signup)
      .with(organization_id: organization_id, email_address: email)
      .and_return(response)
  end

  def allow_successful_invite(response)
    allow(magic_links_email).to receive(:invite)
      .with(
        organization_id: organization_id,
        email_address: email,
        method_options: instance_of(PhcdevworksAccountsStytch::Stytch::MethodOptions)
      )
      .and_return(response)
  end

  def allow_failed_invite
    response = {
      http_status_code: 400,
      stytch_api_error: {
        error_type: 'invite_error',
        error_message: 'Invite error'
      }
    }
    allow(magic_links_email).to receive(:invite)
      .with(
        organization_id: organization_id,
        email_address: email,
        method_options: instance_of(PhcdevworksAccountsStytch::Stytch::MethodOptions)
      )
      .and_return(response)
  end

  def allow_successful_authentication(response)
    allow(magic_links).to receive(:authenticate)
      .with(magic_links_token: magic_links_token)
      .and_return(response)
  end

  def allow_failed_authentication
    response = {
      http_status_code: 400,
      stytch_api_error: {
        error_type: 'auth_error',
        error_message: 'Authentication error'
      }
    }
    allow(magic_links).to receive(:authenticate)
      .with(magic_links_token: magic_links_token)
      .and_return(response)
  end
end
