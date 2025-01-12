require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::SsoController, type: :controller do
  let(:organization_slug) { 'example-org' }
  let(:valid_params) do
    {
      organization_slug: organization_slug,
      connection_id: 'saml-connection-test-51861cbc-d3b9-428b-9761-227f5fb12be9',
      idp_response: 'mocked-saml-response'
    }
  end

  let(:mock_success_response) do
    PhcdevworksAccountsStytch::Stytch::Success.new(
      status_code: 200,
      message: 'Success',
      data: { session_token: 'mock-session-token', member_id: 'member-1234' }
    )
  end

  let(:mock_error_response) do
    PhcdevworksAccountsStytch::Stytch::Error.new(
      status_code: 401,
      error_code: 'authentication_failed',
      error_message: 'Invalid SSO response'
    )
  end

  describe 'POST /phcdevworks_accounts_stytch/b2b/:organization_slug/sso/authenticate' do
    context 'when the request is successful' do
      before do
        allow_any_instance_of(PhcdevworksAccountsStytch::Authentication::B2b::SsoService)
          .to receive(:handle_request)
          .and_return(mock_success_response)
      end

      it 'returns a 200 status and success data' do
        post :authenticate, params: valid_params
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status_code']).to eq(200)
        expect(json_response['data']['session_token']).to eq('mock-session-token')
      end
    end

    context 'when the request fails' do
      before do
        allow_any_instance_of(PhcdevworksAccountsStytch::Authentication::B2b::SsoService)
          .to receive(:handle_request)
          .and_raise(mock_error_response)
      end

      it 'returns the error status and message' do
        post :authenticate, params: valid_params
        expect(response).to have_http_status(401)
        json_response = JSON.parse(response.body)
        expect(json_response['error']['status']).to eq(401)
        expect(json_response['error']['error_code']).to eq('authentication_failed')
        expect(json_response['error']['error_message']).to eq('Invalid SSO response')
      end
    end

    context 'when organization_slug is missing or blank' do
      it 'returns a 400 status with an error message' do
        post :authenticate, params: valid_params.merge(organization_slug: '')
        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('organization_slug is required')
      end
    end
  end
end
