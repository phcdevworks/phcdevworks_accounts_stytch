# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::AuthenticateController, type: :controller do
  routes { PhcdevworksAccountsStytch::Engine.routes }

  let(:magic_link_service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService) }
  let(:password_service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2b::PasswordService) }
  let(:email) { 'user@example.com' }
  let(:password) { 'secure_password' }
  let(:organization_id) { 'organization_123' }
  let(:magic_links_token) { 'some_valid_token' }

  before do
    allow(PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService).to receive(:new).and_return(magic_link_service)
    allow(PhcdevworksAccountsStytch::Authentication::B2b::PasswordService).to receive(:new).and_return(password_service)
  end

  describe 'POST #authenticate' do
    context 'when magic link token is present' do
      before do
        post :authenticate, params: { token: magic_links_token }
      end

      it 'redirects to magic link authentication path' do
        expect(response).to redirect_to(b2b_process_authenticate_path(token: magic_links_token))
      end
    end

    context 'when email, password, and organization ID are present' do
      before do
        post :authenticate, params: { email: email, password: password, organization_id: organization_id }
      end

      it 'redirects to password authentication path' do
        expect(response).to redirect_to(
          b2b_process_authenticate_path(email: email, password: password, organization_id: organization_id)
        )
      end
    end

    context 'when credentials are missing' do
      before do
        post :authenticate, params: {}
      end

      it 'handles missing credentials' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body))
          .to include('error' => 'Magic link token or email, password, and organization ID are required.')
      end
    end

    context 'when an unexpected error occurs' do
      before do
        # Simulate an unexpected error
        allow(controller).to receive(:magic_link_token_present?).and_raise(StandardError.new('Unexpected error'))
        post :authenticate, params: { token: magic_links_token }
      end

      it 'handles unexpected errors' do
        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)).to include('error' => 'An unexpected error occurred.')
      end
    end
  end

  describe 'POST #process_authenticate' do
    context 'when authenticating with a magic link token' do
      let(:success_response) do
        PhcdevworksAccountsStytch::Stytch::Success.new(
          status_code: 200,
          message: 'Authentication successful.',
          data: { 'user_id' => 'user_123' }
        )
      end

      before do
        allow(magic_link_service).to receive(:process_authenticate).with(magic_links_token).and_return(success_response)
        post :process_authenticate, params: { token: magic_links_token }
      end

      it 'returns a success response for magic link authentication' do
        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(parsed_response['message']).to eq('Action completed successfully')
        expect(parsed_response['data']['data']).to include('user_id' => 'user_123')
        expect(parsed_response['data']['message']).to eq('Authentication successful.')
      end
    end

    context 'when magic link authentication fails' do
      let(:error) { PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Authentication error') }

      before do
        allow(magic_link_service).to receive(:process_authenticate).with(magic_links_token).and_raise(error)
        post :process_authenticate, params: { token: magic_links_token }
      end

      it 'returns an error response for magic link authentication failure' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body))
          .to include('error' => 'Stytch Error (Status Code: 400) - Message: Authentication error')
      end
    end

    context 'when authenticating with email, password, and organization ID' do
      let(:success_response) do
        PhcdevworksAccountsStytch::Stytch::Success.new(
          status_code: 200,
          message: 'Authentication successful.',
          data: { 'user_id' => 'user_123' }
        )
      end

      before do
        allow(password_service).to receive(:authenticate_password).with(email, password, organization_id)
                                                                  .and_return(success_response)
        post :process_authenticate, params: { email: email, password: password, organization_id: organization_id }
      end

      it 'returns a success response for password authentication' do
        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(parsed_response['message']).to eq('Action completed successfully')
        expect(parsed_response['data']['data']).to include('user_id' => 'user_123')
        expect(parsed_response['data']['message']).to eq('Authentication successful.')
      end
    end

    context 'when password authentication fails' do
      let(:error) { PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Authentication error') }

      before do
        allow(password_service).to receive(:authenticate_password).with(email, password, organization_id)
                                                                  .and_raise(error)
        post :process_authenticate, params: { email: email, password: password, organization_id: organization_id }
      end

      it 'returns an error response for password authentication failure' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body))
          .to include('error' => 'Stytch Error (Status Code: 400) - Message: Authentication error')
      end
    end

    context 'when credentials are missing' do
      before do
        post :process_authenticate, params: {}
      end

      it 'returns an unprocessable entity response' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body))
          .to include('error' => 'Magic link token or email, password, and organization ID are required.')
      end
    end
  end
end
