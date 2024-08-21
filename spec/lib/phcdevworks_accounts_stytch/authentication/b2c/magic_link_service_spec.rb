require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService, type: :service do
  let(:client) { instance_double(Stytch::Client) }
  let(:email) { 'user@example.com' }
  let(:magic_links_token) { 'some_valid_token' }
  let(:service) { described_class.new }

  before do
    magic_links_email = instance_double(Stytch::MagicLinks::Email)
    allow(client).to receive(:magic_links).and_return(instance_double(Stytch::MagicLinks, email: magic_links_email))
    allow(PhcdevworksAccountsStytch::StytchClient).to receive(:b2c_client).and_return(client)
  end

  describe '#invite' do
    context 'when invite is successful' do
      it 'returns the response' do
        response = { status_code: 200 }
        allow(client.magic_links.email).to receive(:invite)
          .with(email: email)
          .and_return(response)

        expect(service.invite(email)).to eq(response)
      end
    end

    context 'when invite fails' do
      it 'raises a custom error' do
        response = { status_code: 400, error_code: 'invite_error', error_message: 'Invite error' }
        allow(client.magic_links.email).to receive(:invite)
          .with(email: email)
          .and_return(response)

        expect do
          service.invite(email)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error,
                           'Stytch Error (Status Code: 400) - Code: invite_error - Message: Invite error')
      end
    end
  end

  describe '#authenticate' do
    context 'when authentication is successful' do
      it 'returns the response' do
        response = { status_code: 200, 'user_id' => 'user_123' }
        allow(client.magic_links).to receive(:authenticate)
          .with(token: magic_links_token)
          .and_return(response)

        expect(service.authenticate(magic_links_token)).to eq(response)
      end
    end

    context 'when authentication fails' do
      it 'raises a custom error' do
        response = { status_code: 400, error_code: 'auth_error', error_message: 'Authentication error' }
        allow(client.magic_links).to receive(:authenticate)
          .with(token: magic_links_token)
          .and_return(response)

        expect do
          service.authenticate(magic_links_token)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error,
                           'Stytch Error (Status Code: 400) - Code: auth_error - Message: Authentication error')
      end
    end
  end
end
