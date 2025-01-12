require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Authentication::B2b::SsoService, type: :service do
  let(:sso_service) { described_class.new }
  let(:sso_token) { 'mocked-sso-token' }

  let(:mock_success_response) do
    {
      http_status_code: 200,
      data: { session_token: 'mock-session-token', member_id: 'member-1234' }
    }
  end

  let(:mock_error_response) do
    {
      http_status_code: 401,
      stytch_api_error: {
        error_type: 'authentication_failed',
        error_message: 'Invalid SSO response'
      }
    }
  end

  describe '#authenticate_sso' do
    context 'when the authentication is successful' do
      before do
        allow(sso_service.client.sso).to receive(:authenticate).with(
          sso_token: sso_token
        ).and_return(mock_success_response)
      end

      it 'returns a successful response with session token' do
        result = sso_service.authenticate_sso(
          sso_token: sso_token
        )
        expect(result.status_code).to eq(200)
        expect(result.data[:session_token]).to eq('mock-session-token')
      end
    end

    context 'when the authentication fails' do
      before do
        allow(sso_service.client.sso).to receive(:authenticate).with(
          sso_token: sso_token
        ).and_return(mock_error_response)
      end

      it 'raises an error with the correct status and message' do
        expect {
          sso_service.authenticate_sso(
            sso_token: sso_token
          )
        }.to raise_error(PhcdevworksAccountsStytch::Stytch::Error, /authentication_failed: Invalid SSO response/)
      end
    end
  end
end
