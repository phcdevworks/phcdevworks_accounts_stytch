# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::StytchClient do
  describe '.client' do
    context 'with valid credentials' do
      let(:project_id) { 'your_project_id' }
      let(:secret) { 'your_secret' }

      before do
        allow(Rails.application.credentials).to receive(:dig).with(:stytch, :project_id).and_return(project_id)
        allow(Rails.application.credentials).to receive(:dig).with(:stytch, :secret).and_return(secret)
      end

      it 'initializes the StytchB2B client with the correct credentials' do
        client = described_class.client

        expect(client).to be_a(StytchB2B::Client)
      end

      it 'can interact with the Stytch API' do
        client = described_class.client

        magic_links = double('magic_links')
        allow(client).to receive(:magic_links).and_return(magic_links)
        allow(magic_links).to receive(:email).and_return(double('email', login_or_create: true))

        expect(client.magic_links.email.login_or_create(email: 'test@example.com',
                                                        login_magic_link_url: 'http://example.com')).to be_truthy
      end
    end

    context 'with missing credentials' do
      before do
        allow(Rails.application.credentials).to receive(:dig).with(:stytch, :project_id).and_return(nil)
        allow(Rails.application.credentials).to receive(:dig).with(:stytch, :secret).and_return(nil)
      end

      it 'raises an error' do
        expect { described_class.client }.to raise_error('Stytch credentials are missing')
      end
    end
  end
end
