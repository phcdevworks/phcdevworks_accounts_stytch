# spec/lib/phcdevworks_accounts_stytch/authentication/b2_b/magic_link_service_spec.rb

# frozen_string_literal: true

require 'rails_helper'
require 'phcdevworks_accounts_stytch/authentication/b2b/magic_link_service'

module Stytch
  class Error < StandardError; end
end

RSpec.describe PhcdevworksAccountsStytch::Authentication::B2B::MagicLinkService, type: :service do
  let(:client) { instance_double(StytchB2B::Client) }
  let(:magic_links_email) { instance_double(StytchB2B::MagicLinks::Email) }
  let(:email) { 'user@example.com' }
  let(:organization_id) { 'org_123' }
  let(:token) { 'some_valid_token' }
  let(:service) { described_class.new }

  before do
    allow(client).to receive(:magic_links).and_return(instance_double(StytchB2B::MagicLinks, email: magic_links_email))
    allow(PhcdevworksAccountsStytch::StytchClient).to receive(:b2b_client).and_return(client)
  end

  describe '#invite' do
    it 'successfully sends an invite' do
      allow(magic_links_email).to receive(:invite)
        .with(organization_id: organization_id, email_address: email)
        .and_return(true)

      expect(service.invite(email, organization_id)).to be_truthy
    end

    it 'handles errors gracefully' do
      allow(magic_links_email).to receive(:invite)
        .with(organization_id: organization_id, email_address: email)
        .and_raise(Stytch::Error.new('Invite error'))

      expect(service.invite(email, organization_id)).to be_nil
    end
  end

  describe '#authenticate' do
    it 'successfully authenticates a user with a magic link' do
      response = { 'user_id' => 'user_123' }
      allow(client.magic_links).to receive(:authenticate)
        .with(magic_links_token: token)
        .and_return(response)

      expect(service.authenticate(token)).to eq(response)
    end

    it 'handles errors gracefully' do
      allow(client.magic_links).to receive(:authenticate)
        .with(magic_links_token: token)
        .and_raise(Stytch::Error.new('Authentication error'))

      expect(service.authenticate(token)).to be_nil
    end
  end
end
