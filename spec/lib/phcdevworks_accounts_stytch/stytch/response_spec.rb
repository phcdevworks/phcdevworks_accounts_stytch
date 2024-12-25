require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::Response do
  describe '.handle_response' do
    context 'when the response is successful' do
      let(:response) { { http_status_code: 200, data: { 'message' => 'Success' } } }

      it 'returns a success object' do
        result = described_class.handle_response(response)
        expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
        expect(result.status_code).to eq(200)
        expect(result.data).to eq({ 'message' => 'Success' })
      end
    end

    context 'when the response is an error' do
      let(:response) { { http_status_code: 401, stytch_api_error: { error_type: 'unauthorized', error_message: 'Invalid token' } } }

      it 'raises a Stytch::Error' do
        expect {
          described_class.handle_response(response)
        }.to raise_error(PhcdevworksAccountsStytch::Stytch::Error) do |error|
          expect(error.status_code).to eq(401)
          expect(error.error_code).to eq('unauthorized')
          expect(error.error_message).to eq('Invalid token')
        end
      end
    end
  end
end
