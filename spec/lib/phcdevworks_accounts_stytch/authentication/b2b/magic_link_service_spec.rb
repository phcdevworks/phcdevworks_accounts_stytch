# frozen_string_literal: true

require 'rails_helper'
require 'phcdevworks_accounts_stytch/authentication/b2b/magic_link_service'

module Stytch
  class Error < StandardError; end
end

RSpec.describe PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService, type: :service do
  let(:client) { instance_double(StytchB2B::Client) }
  let(:email) { 'user@example.com' }
  let(:organization_id) { 'org_123' }
  let(:token) { 'some_valid_token' }
  let(:service) { described_class.new }

  before do
    magic_links_email = instance_double(StytchB2B::MagicLinks::Email)
    allow(client).to receive(:magic_links).and_return(instance_double(StytchB2B::MagicLinks, email: magic_links_email))
    allow(PhcdevworksAccountsStytch::StytchClient).to receive(:b2b_client).and_return(client)
  end

  describe '#invite' do
    context 'when invite is successful' do
      it 'returns true' do
        allow(client.magic_links.email).to receive(:invite)
          .with(organization_id: organization_id, email_address: email)
          .and_return(true)

        expect(service.invite(email, organization_id)).to be_truthy
      end
    end

    context 'when invite fails' do
      it 'handles the error and returns nil' do
        allow(client.magic_links.email).to receive(:invite)
          .with(organization_id: organization_id, email_address: email)
          .and_raise(Stytch::Error.new('Invite error'))

        expect(service.invite(email, organization_id)).to be_nil
      end
    end
  end

  describe '#authenticate' do
    context 'when authentication is successful' do
      it 'returns the response' do
        response = { 'user_id' => 'user_123' }
        allow(client.magic_links).to receive(:authenticate)
          .with(magic_links_token: token)
          .and_return(response)

        expect(service.authenticate(token)).to eq(response)
      end
    end

    context 'when authentication fails' do
      it 'handles the error and returns nil' do
        allow(client.magic_links).to receive(:authenticate)
          .with(magic_links_token: token)
          .and_raise(Stytch::Error.new('Authentication error'))

        expect(service.authenticate(token)).to be_nil
      end
    end
  end
end
