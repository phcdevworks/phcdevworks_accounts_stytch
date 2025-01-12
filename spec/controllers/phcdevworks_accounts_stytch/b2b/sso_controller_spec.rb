require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::SsoController, type: :controller do
  let(:organization_slug) { 'example-org' }
  let(:valid_params) do
    {
      organization_slug: organization_slug,
      sso_token: 'mocked-sso-token'
    }
  end

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

  describe 'POST /phcdevworks_accounts_stytch/b2b/:organization_slug/sso/authenticate' do
    before do
      allow_any_instance_of(PhcdevworksAccountsStytch::Authentication::B2b::SsoService).to receive(:client)
        .and_return(double('StytchB2B::Client', sso: sso_double))
    end

    let(:sso_double) { double('SSO', authenticate: mock_success_response) }

    context 'when the request is successful' do
      it 'returns a 200 status and success data' do
        post :authenticate, params: valid_params
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status_code']).to eq(200)
        expect(json_response['data']['session_token']).to eq('mock-session-token')
      end
    end

    context 'when the request fails' do
      let(:sso_double) { double('SSO', authenticate: mock_error_response) }

      it 'returns the error status and message' do
        allow(sso_double).to receive(:authenticate).and_raise(
          PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: 401,
            error_code: 'authentication_failed',
            error_message: 'Invalid SSO response'
          )
        )
        post :authenticate, params: valid_params
        expect(response).to have_http_status(401)
        json_response = JSON.parse(response.body)
        expect(json_response['error']['status']).to eq(401)
        expect(json_response['error']['error_code']).to eq('authentication_failed')
        expect(json_response['error']['error_message']).to eq('Invalid SSO response')
      end
    end

    context 'when organization_slug is blank' do
      it 'returns a 400 status with an error message' do
        post :authenticate, params: valid_params.merge(organization_slug: '')
        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('organization_slug is required')
      end
    end

    context 'when organization_slug is invalid or missing' do
      it 'returns a 400 status with an error message' do
        post :authenticate, params: valid_params.merge(organization_slug: '_invalid_')
        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('organization_slug is required')
      end
    end
  end
end
