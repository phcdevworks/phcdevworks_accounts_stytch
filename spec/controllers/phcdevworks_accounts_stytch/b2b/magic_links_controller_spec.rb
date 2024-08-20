# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::MagicLinksController, type: :controller do
  routes { PhcdevworksAccountsStytch::Engine.routes }

  let(:service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService) }
  let(:email) { 'user@example.com' }
  let(:organization_id) { 'org_123' }
  let(:session_token) { 'some_session_token' }
  let(:token) { 'some_valid_token' }

  before do
    allow(PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService).to receive(:new).and_return(service)
  end

  describe 'POST #process_invite' do
    context 'when email or organization_id is missing' do
      it 'returns an unprocessable entity response' do
        post :process_invite, params: { email: '', organization_id: '' }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Email and Organization ID are required.')
      end
    end

    context 'when the invite is successful' do
      it 'returns a success response' do
        allow(service).to receive(:process_invite).and_return(true)

        post :process_invite, params: { email: email, organization_id: organization_id, session_token: session_token },
                              format: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Action completed successfully.')
      end
    end

    context 'when the invite fails' do
      it 'returns an error response' do
        error_message = 'An error occurred with Stytch'
        allow(service).to receive(:process_invite).and_raise(PhcdevworksAccountsStytch::Stytch::Error.new(error_message: error_message))

        post :process_invite, params: { email: email, organization_id: organization_id, session_token: session_token },
                              format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to match(/#{error_message}/)
      end
    end
  end

  describe 'POST #process_login_or_signup' do
    context 'when the login or signup is successful' do
      it 'returns a success response' do
        allow(service).to receive(:process_login_or_signup).and_return(true)

        post :process_login_or_signup, params: { email: email, organization_id: organization_id }, format: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Action completed successfully.')
      end
    end

    context 'when the login or signup fails' do
      it 'returns an error response' do
        error_message = 'An error occurred with Stytch'
        allow(service).to receive(:process_login_or_signup).and_raise(PhcdevworksAccountsStytch::Stytch::Error.new(error_message: error_message))

        post :process_login_or_signup, params: { email: email, organization_id: organization_id }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to match(/#{error_message}/)
      end
    end
  end

  describe 'POST #process_authenticate' do
    context 'when the authentication is successful' do
      it 'returns a success response' do
        allow(service).to receive(:process_authenticate).and_return({ 'user_id' => 'user_123' })

        post :process_authenticate, params: { token: token }, format: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Action completed successfully.')
        expect(JSON.parse(response.body)['result']['user_id']).to eq('user_123')
      end
    end

    context 'when the authentication fails' do
      it 'returns an error response' do
        error_message = 'An error occurred with Stytch'
        allow(service).to receive(:process_authenticate).and_raise(PhcdevworksAccountsStytch::Stytch::Error.new(error_message: error_message))

        post :process_authenticate, params: { token: token }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to match(/#{error_message}/)
      end
    end
  end
end
