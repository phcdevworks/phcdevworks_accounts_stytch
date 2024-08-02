# spec/lib/phcdevworks_accounts_stytch/stytch_client_spec.rb

require 'rails_helper'

module PhcdevworksAccountsStytch
  RSpec.describe StytchClient do
    let(:b2b_project_id) { 'b2b_project_id' }
    let(:b2b_secret) { 'b2b_secret' }
    let(:b2c_project_id) { 'b2c_project_id' }
    let(:b2c_secret) { 'b2c_secret' }

    before do
      allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2b, :project_id).and_return(b2b_project_id)
      allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2b, :secret).and_return(b2b_secret)
      allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2c, :project_id).and_return(b2c_project_id)
      allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2c, :secret).and_return(b2c_secret)

      # Clear memoized instance variables before each test
      PhcdevworksAccountsStytch::StytchClient.instance_variable_set(:@b2b_client, nil)
      PhcdevworksAccountsStytch::StytchClient.instance_variable_set(:@b2c_client, nil)
    end

    describe '.b2b_client' do
      it 'initializes the B2B client with correct credentials' do
        expect(StytchB2B::Client).to receive(:new).with(project_id: b2b_project_id, secret: b2b_secret)
        StytchClient.b2b_client
      end

      it 'raises an error if B2B credentials are missing' do
        allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2b, :project_id).and_return(nil)
        allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2b, :secret).and_return(nil)

        expect { StytchClient.b2b_client }.to raise_error('Stytch B2B credentials are missing')
      end
    end

    describe '.b2c_client' do
      it 'initializes the B2C client with correct credentials' do
        expect(Stytch::Client).to receive(:new).with(project_id: b2c_project_id, secret: b2c_secret)
        StytchClient.b2c_client
      end

      it 'raises an error if B2C credentials are missing' do
        allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2c, :project_id).and_return(nil)
        allow(Rails.application.credentials).to receive(:dig).with(:stytch, :b2c, :secret).and_return(nil)

        expect { StytchClient.b2c_client }.to raise_error('Stytch B2C credentials are missing')
      end
    end
  end
end
