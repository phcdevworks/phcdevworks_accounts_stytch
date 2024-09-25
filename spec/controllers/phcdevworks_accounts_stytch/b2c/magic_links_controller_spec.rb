# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2c::MagicLinksController, type: :controller do
  routes { PhcdevworksAccountsStytch::Engine.routes }

  let(:service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService) }
  let(:email) { 'user@example.com' }

  before do
    result = { data: { key: 'value' } }

    allow(PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService).to receive(:new).and_return(service)
    allow(service).to receive(:process_revoke_invite).with('user@example.com').and_return(result)

    post :process_revoke_invite, params: { email: 'user@example.com' }
  end

  describe 'POST #process_login_or_signup' do
    context 'when required params are missing' do
      before do
        post :process_login_or_signup, params: { email: '' }
      end

      it 'returns an error when email is missing' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => 'Email is required.')
      end
    end

    context 'when login or signup is successful' do
      let(:success_response) do
        instance_double(
          PhcdevworksAccountsStytch::Stytch::Success, message: 'Action completed successfully', data: { key: 'value' }
        )
      end

      before do
        allow(service).to receive(:process_login_or_signup).with(email).and_return(success_response)
        post :process_login_or_signup, params: { email: email }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message' => 'Action completed successfully')
      end
    end

    context 'when login or signup fails' do
      let(:error) { PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Login error') }

      before do
        allow(service).to receive(:process_login_or_signup).with(email).and_raise(error)
        post :process_login_or_signup, params: { email: email }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include('error' => 'Stytch Error (Status Code: 400) - Message: Login error')
      end
    end
  end

  describe 'POST #process_invite' do
    context 'when email or organization slug is missing' do
      before do
        post :process_invite, params: { email: '', organization_slug: 'example-org' }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => 'Email is required.')
      end
    end

    context 'when invite is successful' do
      let(:success_response) do
        instance_double(
          PhcdevworksAccountsStytch::Stytch::Success, message: 'Action completed successfully', data: { key: 'value' }
        )
      end

      before do
        allow(service).to receive(:process_invite).with(email).and_return(success_response)
        post :process_invite, params: { email: email }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message' => 'Action completed successfully')
      end
    end

    context 'when invite fails' do
      let(:error) { PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Invite error') }

      before do
        allow(service).to receive(:process_invite).with(email).and_raise(error)
        post :process_invite, params: { email: email }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body))
          .to include('error' => 'Stytch Error (Status Code: 400) - Message: Invite error')
      end
    end
  end

  describe 'POST #process_revoke_invite' do
    context 'when email is missing' do
      before do
        post :process_revoke_invite, params: { email: '' }
      end

      it 'returns an error when email is missing' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => 'Email is required.')
      end
    end

    context 'when revoke invite is successful' do
      before do
        success_response = { message: 'Invite revoked successfully', data: { key: 'value' } }
        allow(service).to receive(:process_revoke_invite).with('user@example.com').and_return(success_response)
        post :process_revoke_invite, params: { email: 'user@example.com' }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message' => 'Invite revoked successfully')
      end
    end

    context 'when revoke invite fails due to API error' do
      before do
        error = PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Revoke error')
        allow(service).to receive(:process_revoke_invite).with('user@example.com').and_raise(error)
        post :process_revoke_invite, params: { email: 'user@example.com' }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include('error' => 'Stytch Error (Status Code: 400) - Message: Revoke error')
      end
    end

    context 'when an unexpected error occurs' do
      before do
        allow(service).to receive(:process_revoke_invite).with('user@example.com').and_raise(
          StandardError.new('Unexpected error')
        )
        post :process_revoke_invite, params: { email: 'user@example.com' }
      end

      it 'returns a 500 error response' do
        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)).to include('error' => 'An unexpected error occurred.')
      end
    end

    context 'when result is not a hash with a message' do
      before do
        # Return a response without a message to simulate the failure case
        result = { data: { key: 'value' } }
        allow(service).to receive(:process_revoke_invite).with('user@example.com').and_return(result)
        post :process_revoke_invite, params: { email: 'user@example.com' }
      end

      it 'returns a generic success message' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message' => 'Action completed successfully')
      end
    end

    context 'when result is a hash with a message' do
      before do
        result = { message: 'Revoke successful', data: { key: 'value' } }
        allow(service).to receive(:process_revoke_invite).with('user@example.com').and_return(result)
        post :process_revoke_invite, params: { email: 'user@example.com' }
      end

      it 'returns the message from the result' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message' => 'Revoke successful', 'data' => { 'key' => 'value' })
      end
    end
  end
end
