# frozen_string_literal: true

require 'rails_helper'
require 'phcdevworks_accounts_stytch/authentication/b2c/magic_link_service'

module Stytch
  class Error < StandardError; end
end

RSpec.describe PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService, type: :service do
  let(:client) { instance_double(Stytch::Client) }
  let(:magic_links_email) { instance_double(Stytch::MagicLinks::Email) }
  let(:email) { 'user@example.com' }
  let(:token) { 'some_valid_token' }
  let(:service) { described_class.new }

  before do
    allow(client).to receive(:magic_links).and_return(instance_double(Stytch::MagicLinks, email: magic_links_email))
    allow(PhcdevworksAccountsStytch::StytchClient).to receive(:b2c_client).and_return(client)
  end

  describe '#login_or_create' do
    it 'successfully logs in or creates a user' do
      response = { 'user_id' => 'user_123' }
      allow(magic_links_email).to receive(:login_or_create)
        .with(email: email)
        .and_return(response)

      expect(service.login_or_create(email)).to eq(response)
    end

    it 'handles errors gracefully' do
      allow(magic_links_email).to receive(:login_or_create)
        .with(email: email)
        .and_raise(Stytch::Error.new('Login error'))

      expect(service.login_or_create(email)).to be_nil
    end
  end

  describe '#send_magic_link' do
    it 'successfully sends a magic link' do
      allow(magic_links_email).to receive(:send)
        .with(email: email)
        .and_return(true)

      expect(service.send_magic_link(email)).to be_truthy
    end

    it 'handles errors gracefully' do
      allow(magic_links_email).to receive(:send)
        .with(email: email)
        .and_raise(Stytch::Error.new('Send error'))

      expect(service.send_magic_link(email)).to be_nil
    end
  end

  describe '#invite' do
    it 'successfully sends an invite' do
      allow(magic_links_email).to receive(:invite)
        .with(email: email)
        .and_return(true)

      expect(service.invite(email)).to be_truthy
    end

    it 'handles errors gracefully' do
      allow(magic_links_email).to receive(:invite)
        .with(email: email)
        .and_raise(Stytch::Error.new('Invite error'))

      expect(service.invite(email)).to be_nil
    end
  end

  describe '#revoke_invite' do
    it 'successfully revokes an invite' do
      allow(magic_links_email).to receive(:revoke_invite)
        .with(email: email)
        .and_return(true)

      expect(service.revoke_invite(email)).to be_truthy
    end

    it 'handles errors gracefully' do
      allow(magic_links_email).to receive(:revoke_invite)
        .with(email: email)
        .and_raise(Stytch::Error.new('Revoke invite error'))

      expect(service.revoke_invite(email)).to be_nil
    end
  end

  describe '#authenticate' do
    it 'successfully authenticates a user with a magic link' do
      response = { 'user_id' => 'user_123' }
      allow(client.magic_links).to receive(:authenticate)
        .with(token: token)
        .and_return(response)

      expect(service.authenticate(token)).to eq(response)
    end

    it 'handles errors gracefully' do
      allow(client.magic_links).to receive(:authenticate)
        .with(token: token)
        .and_raise(Stytch::Error.new('Authentication error'))

      expect(service.authenticate(token)).to be_nil
    end
  end
end
