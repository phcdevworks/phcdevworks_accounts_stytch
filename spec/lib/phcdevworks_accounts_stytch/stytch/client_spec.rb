require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::Client do
  class MockStytchB2BClient
    def initialize(project_id:, secret:)
      @project_id = project_id
      @secret = secret
    end
  end

  class MockStytchB2CClient
    def initialize(project_id:, secret:)
      @project_id = project_id
      @secret = secret
    end
  end

  describe 'class methods' do
    before do
      described_class.instance_variable_set(:@b2b_client, nil)
      described_class.instance_variable_set(:@b2c_client, nil)
    end

    describe '.b2b_client' do
      context 'when B2B credentials are missing' do
        before do
          allow(Rails.application.credentials).to receive(:dig)
            .with(:stytch, :b2b, :project_id)
            .and_return(nil)
          allow(Rails.application.credentials).to receive(:dig)
            .with(:stytch, :b2b, :secret)
            .and_return(nil)
        end

        it 'raises a credentials missing error' do
          expect {
            described_class.b2b_client
          }.to raise_error(
            PhcdevworksAccountsStytch::Stytch::Error,
            /Stytch Error \(Status Code: 500\) - Code: unknown_error - Message: Stytch B2B credentials are missing/
          )
        end
      end
    end

    describe '.b2c_client' do
      context 'when B2C credentials are missing' do
        before do
          allow(Rails.application.credentials).to receive(:dig)
            .with(:stytch, :b2c, :project_id)
            .and_return(nil)
          allow(Rails.application.credentials).to receive(:dig)
            .with(:stytch, :b2c, :secret)
            .and_return(nil)
        end

        it 'raises a credentials missing error' do
          expect {
            described_class.b2c_client
          }.to raise_error(
            PhcdevworksAccountsStytch::Stytch::Error,
            /Stytch Error \(Status Code: 500\) - Code: unknown_error - Message: Stytch B2C credentials are missing/
          )
        end
      end
    end

    describe '.b2b_client' do
      context 'when B2B credentials are present' do
        before do
          allow(Rails.application.credentials).to receive(:dig)
            .with(:stytch, :b2b, :project_id)
            .and_return('test_b2b_project_id')
          allow(Rails.application.credentials).to receive(:dig)
            .with(:stytch, :b2b, :secret)
            .and_return('test_b2b_secret')
          
          stub_const('StytchB2B::Client', MockStytchB2BClient)
        end

        it 'creates and returns a B2B Stytch client' do
          client = described_class.b2b_client
          
          expect(client).to be_a(MockStytchB2BClient)
          expect(client.instance_variable_get(:@project_id)).to eq('test_b2b_project_id')
          expect(client.instance_variable_get(:@secret)).to eq('test_b2b_secret')
        end

        it 'memoizes the B2B client' do
          first_client = described_class.b2b_client
          second_client = described_class.b2b_client

          expect(first_client).to be(second_client)
        end
      end
    end

    describe '.b2c_client' do
      context 'when B2C credentials are present' do
        before do
          allow(Rails.application.credentials).to receive(:dig)
            .with(:stytch, :b2c, :project_id)
            .and_return('test_b2c_project_id')
          allow(Rails.application.credentials).to receive(:dig)
            .with(:stytch, :b2c, :secret)
            .and_return('test_b2c_secret')
          
          stub_const('Stytch::Client', MockStytchB2CClient)
        end

        it 'creates and returns a B2C Stytch client' do
          client = described_class.b2c_client
          
          expect(client).to be_a(MockStytchB2CClient)
          expect(client.instance_variable_get(:@project_id)).to eq('test_b2c_project_id')
          expect(client.instance_variable_get(:@secret)).to eq('test_b2c_secret')
        end

        it 'memoizes the B2C client' do
          first_client = described_class.b2c_client
          second_client = described_class.b2c_client

          expect(first_client).to be(second_client)
        end
      end
    end
  end
end
