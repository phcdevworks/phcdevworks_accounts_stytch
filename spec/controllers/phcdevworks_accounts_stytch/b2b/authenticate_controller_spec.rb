require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::AuthenticateController, type: :controller do
  describe 'POST #create' do
    let(:mock_service) { instance_double(PhcdevworksAccountsStytch::Authentication::BaseService) }
    let(:mock_client) { double('MockStytchClient') }
    let(:mock_sessions) { double('MockStytchSessions') }
    let(:mock_response) { PhcdevworksAccountsStytch::Stytch::Success.new(status_code: 200, message: 'Success', data: { authenticated: true }) }
    let(:mock_error) do
      PhcdevworksAccountsStytch::Stytch::Error.new(
        status_code: 400,
        error_code: 'mock_error',
        error_message: 'A mock error occurred'
      )
    end

    before do
      allow(PhcdevworksAccountsStytch::Authentication::BaseService).to receive(:new).and_return(mock_service)
      allow(mock_service).to receive(:client).and_return(mock_client)
      allow(mock_client).to receive(:sessions).and_return(mock_sessions)
    end

    context 'when authentication is successful' do
      before do
        allow(mock_sessions).to receive(:authenticate).and_return(mock_response)
        allow(mock_service).to receive(:handle_request).and_yield
      end

      it 'returns a success response' do
        post :create, params: { session_token: 'valid_token' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']).to eq({ 'authenticated' => true })
      end
    end

    context 'when authentication fails' do
      before do
        allow(mock_service).to receive(:handle_request).and_raise(mock_error)
      end

      it 'returns an error response' do
        post :create, params: { session_token: 'invalid_token' }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']['error_code']).to eq('mock_error')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:mock_service) { instance_double(PhcdevworksAccountsStytch::Authentication::BaseService) }
    let(:mock_client) { double('MockStytchClient') }
    let(:mock_sessions) { double('MockStytchSessions') }
    let(:mock_response) { PhcdevworksAccountsStytch::Stytch::Success.new(status_code: 200, message: 'Session revoked', data: { revoked: true }) }
    let(:mock_error) do
      PhcdevworksAccountsStytch::Stytch::Error.new(
        status_code: 400,
        error_code: 'mock_error',
        error_message: 'A mock error occurred'
      )
    end

    before do
      allow(PhcdevworksAccountsStytch::Authentication::BaseService).to receive(:new).and_return(mock_service)
      allow(mock_service).to receive(:client).and_return(mock_client)
      allow(mock_client).to receive(:sessions).and_return(mock_sessions)
    end

    context 'when session revocation is successful' do
      before do
        allow(mock_sessions).to receive(:revoke).and_return(mock_response)
        allow(mock_service).to receive(:handle_request).and_yield
      end

      it 'returns a success response' do
        delete :destroy, params: { session_token: 'valid_token' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']).to eq({ 'revoked' => true })
      end
    end

    context 'when session revocation fails' do
      before do
        allow(mock_sessions).to receive(:revoke).and_raise(mock_error)
        allow(mock_service).to receive(:handle_request).and_raise(mock_error)
      end

      it 'returns an error response' do
        delete :destroy, params: { session_token: 'invalid_token' }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']['error_code']).to eq('mock_error')
      end
    end
  end
end
