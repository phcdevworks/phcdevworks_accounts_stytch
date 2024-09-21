# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::Client do
  let(:b2b_project_id) { 'b2b_project_id' }
  let(:b2b_secret) { 'b2b_secret' }
  let(:b2c_project_id) { 'b2c_project_id' }
  let(:b2c_secret) { 'b2c_secret' }

  before do
    allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2b, :project_id).and_return(b2b_project_id)
    allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2b, :secret).and_return(b2b_secret)
    allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2c, :project_id).and_return(b2c_project_id)
    allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2c, :secret).and_return(b2c_secret)

    described_class.instance_variable_set(:@b2b_client, nil)
    described_class.instance_variable_set(:@b2c_client, nil)
  end

  describe '.b2b_client' do
    let(:client) { instance_double(StytchB2B::Client) }

    before do
      allow(StytchB2B::Client).to receive(:new).and_return(client)
    end

    it 'initializes the B2B client with correct credentials' do
      described_class.b2b_client
      expect(StytchB2B::Client).to have_received(:new).with(project_id: b2b_project_id, secret: b2b_secret)
    end

    it 'returns the same instance on subsequent calls' do
      first_call = described_class.b2b_client
      second_call = described_class.b2b_client
      expect(first_call).to eq(second_call)
    end

    it 'raises a custom error if B2B credentials are missing' do
      allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2b, :project_id).and_return(nil)
      allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2b, :secret).and_return(nil)

      expect do
        described_class.b2b_client
      end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error, /Stytch B2B credentials are missing/)
    end
  end

  describe '.b2c_client' do
    let(:client) { instance_double(::Stytch::Client) }

    before do
      allow(::Stytch::Client).to receive(:new).and_return(client)
    end

    it 'initializes the B2C client with correct credentials' do
      described_class.b2c_client
      expect(::Stytch::Client).to have_received(:new).with(project_id: b2c_project_id, secret: b2c_secret)
    end

    it 'returns the same instance on subsequent calls' do
      first_call = described_class.b2c_client
      second_call = described_class.b2c_client
      expect(first_call).to eq(second_call)
    end

    it 'raises a custom error if B2C credentials are missing' do
      allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2c, :project_id).and_return(nil)
      allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2c, :secret).and_return(nil)

      expect do
        described_class.b2c_client
      end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error, /Stytch B2C credentials are missing/)
    end
  end
end
