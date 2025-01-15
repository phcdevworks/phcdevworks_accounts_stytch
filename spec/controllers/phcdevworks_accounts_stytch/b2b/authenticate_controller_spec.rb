require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::AuthenticateController, type: :controller do
  # Shared variables and doubles for all tests
  let(:mock_service) { instance_double(PhcdevworksAccountsStytch::Authentication::BaseService) }
  let(:mock_client) { double('MockStytchClient') }
  let(:mock_sessions) { double('MockStytchSessions') }
  let(:mock_magic_links) { double('MockStytchMagicLinks') }
  let(:mock_passwords) { double('MockStytchPasswords') }
  let(:mock_sso) { double('MockStytchSSO') }
  let(:mock_oauth) { double('MockStytchOAuth') }
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
    allow(mock_client).to receive(:magic_links).and_return(mock_magic_links)
    allow(mock_client).to receive(:passwords).and_return(mock_passwords)
    allow(mock_client).to receive(:sso).and_return(mock_sso)
    allow(mock_client).to receive(:oauth).and_return(mock_oauth)
  end

  describe 'POST #create' do
    context 'when auth_type is session' do
      context 'when authentication is successful' do
        before do
          allow(mock_sessions).to receive(:authenticate).and_return(mock_response)
          allow(mock_service).to receive(:handle_request).and_yield
        end

        it 'returns a success response' do
          post :create, params: { auth_type: 'session', session_token: 'valid_token' }
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['data']).to eq({ 'authenticated' => true })
        end
      end

      context 'when authentication fails' do
        before do
          allow(mock_service).to receive(:handle_request).and_raise(mock_error)
        end

        it 'returns an error response' do
          post :create, params: { auth_type: 'session', session_token: 'invalid_token' }
          expect(response).to have_http_status(:bad_request)
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['error']['error_code']).to eq('mock_error')
        end
      end
    end

    context 'when auth_type is magic_link' do
      context 'when authentication is successful' do
        before do
          allow(mock_magic_links).to receive(:authenticate).and_return(mock_response)
          allow(mock_service).to receive(:handle_request).and_yield
        end

        it 'returns a success response' do
          post :create, params: { auth_type: 'magic_link', magic_links_token: 'valid_token' }
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['data']).to eq({ 'authenticated' => true })
        end
      end

      context 'when authentication fails' do
        before do
          allow(mock_magic_links).to receive(:authenticate).and_raise(mock_error)
          allow(mock_service).to receive(:handle_request).and_raise(mock_error)
        end

        it 'returns an error response' do
          post :create, params: { auth_type: 'magic_link', magic_links_token: 'invalid_token' }
          expect(response).to have_http_status(:bad_request)
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['error']['error_code']).to eq('mock_error')
        end
      end
    end

    context 'when auth_type is password' do
      context 'when authentication is successful' do
        before do
          allow(mock_passwords).to receive(:authenticate).and_return(mock_response)
          allow(mock_service).to receive(:handle_request).and_yield
        end

        it 'returns a success response' do
          post :create, params: { auth_type: 'password', email: 'user@example.com', password: 'password123' }
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['data']).to eq({ 'authenticated' => true })
        end
      end

      context 'when authentication fails' do
        before do
          allow(mock_passwords).to receive(:authenticate).and_raise(mock_error)
          allow(mock_service).to receive(:handle_request).and_raise(mock_error)
        end

        it 'returns an error response' do
          post :create, params: { auth_type: 'password', email: 'user@example.com', password: 'wrongpassword' }
          expect(response).to have_http_status(:bad_request)
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['error']['error_code']).to eq('mock_error')
        end
      end
    end

    context 'when auth_type is sso' do
      context 'when authentication is successful' do
        before do
          allow(mock_sso).to receive(:authenticate).and_return(mock_response)
          allow(mock_service).to receive(:handle_request).and_yield
        end

        it 'returns a success response' do
          post :create, params: { auth_type: 'sso', sso_token: 'valid_sso_token', organization_id: 'org123' }
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['data']).to eq({ 'authenticated' => true })
        end
      end

      context 'when authentication fails' do
        before do
          allow(mock_sso).to receive(:authenticate).and_raise(mock_error)
          allow(mock_service).to receive(:handle_request).and_raise(mock_error)
        end

        it 'returns an error response' do
          post :create, params: { auth_type: 'sso', sso_token: 'invalid_sso_token', organization_id: 'org123' }
          expect(response).to have_http_status(:bad_request)
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['error']['error_code']).to eq('mock_error')
        end
      end
    end

    context 'when auth_type is oauth' do
      context 'when authentication is successful' do
        before do
          allow(mock_oauth).to receive(:authenticate).and_return(mock_response)
          allow(mock_service).to receive(:handle_request).and_yield
        end

        it 'returns a success response' do
          post :create, params: { auth_type: 'oauth', oauth_token: 'valid_oauth_token', organization_id: 'org123' }
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['data']).to eq({ 'authenticated' => true })
        end
      end

      context 'when authentication fails' do
        before do
          allow(mock_oauth).to receive(:authenticate).and_raise(mock_error)
          allow(mock_service).to receive(:handle_request).and_raise(mock_error)
        end

        it 'returns an error response' do
          post :create, params: { auth_type: 'oauth', oauth_token: 'invalid_oauth_token', organization_id: 'org123' }
          expect(response).to have_http_status(:bad_request)
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['error']['error_code']).to eq('mock_error')
        end
      end
    end

    context 'when unsupported auth_type is provided' do
      it 'returns a bad request response' do
        post :create, params: { auth_type: 'unsupported', session_token: 'valid_token' }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']['error_code']).to eq('invalid_auth_type')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when session revocation is successful' do
      before do
        allow(mock_sessions).to receive(:revoke).and_return(mock_response)
        allow(mock_service).to receive(:handle_request).and_yield
      end

      it 'returns a success response' do
        delete :destroy, params: { session_token: 'valid_token' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']).to eq({ 'authenticated' => true })
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
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error']['error_code']).to eq('mock_error')
      end
    end
  end
end
