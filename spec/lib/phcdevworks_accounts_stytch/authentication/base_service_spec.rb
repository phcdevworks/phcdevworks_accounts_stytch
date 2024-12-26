require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Authentication::BaseService do
  let(:mock_response) { { http_status_code: 200, data: { success: true } } }
  let(:mock_error) do
    PhcdevworksAccountsStytch::Stytch::Error.new(
      status_code: 400,
      error_code: 'mock_error',
      error_message: 'A mock error occurred'
    )
  end

  # Mock client class
  class MockStytchClient
    def mock_api_call
      { http_status_code: 200, data: { success: true } }
    end
  end

  let(:mock_client) { MockStytchClient.new }

  describe '#initialize' do
    it 'initializes with a B2B client by default' do
      service = described_class.new
      allow(service).to receive(:client).and_return(mock_client)
      expect(service.client).to eq(mock_client)
    end

    it 'initializes with a B2C client when specified' do
      service = described_class.new
      allow(service).to receive(:client).and_return(mock_client)
      expect(service.client).to eq(mock_client)
    end
  end

  describe '#handle_request' do
    let(:service) { described_class.new }

    it 'handles successful responses' do
      allow(service).to receive(:client).and_return(mock_client)

      result = service.handle_request { service.client.mock_api_call }
      expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
      expect(result.status_code).to eq(200)
    end

    it 'handles errors gracefully' do
      allow(service).to receive(:client).and_return(mock_client)
      allow(mock_client).to receive(:mock_api_call).and_raise(mock_error)

      expect {
        service.handle_request { service.client.mock_api_call }
      }.to raise_error(PhcdevworksAccountsStytch::Stytch::Error)
    end
  end
end
