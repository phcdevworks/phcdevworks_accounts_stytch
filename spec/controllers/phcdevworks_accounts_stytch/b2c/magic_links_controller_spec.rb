# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2c::MagicLinksController, type: :controller do
  routes { PhcdevworksAccountsStytch::Engine.routes }

  let(:email) { 'user@example.com' }
  let(:token) { 'some_valid_token' }
  let(:service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService) }
  let(:stytch_error) { PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_code: 'error_code', error_message: 'An error occurred') }

  before do
    allow(PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService).to receive(:new).and_return(service)
  end

  describe 'POST #process_login_or_signup' do
    context 'when login or signup is successful' do
      before do
        allow(service).to receive(:process_login_or_signup).and_return(instance_double('Result', message: 'Success', data: { 'user_id' => 'user_123' }))
        post :process_login_or_signup, params: { email: email }, format: :json
      end

      it 'returns a success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct user_id' do
        expect(JSON.parse(response.body)['data']['user_id']).to eq('user_123')
      end
    end

    context 'when login or signup fails' do
      before do
        allow(service).to receive(:process_login_or_signup).and_raise(stytch_error)
        post :process_login_or_signup, params: { email: email }, format: :json
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST #process_invite' do
    context 'when invite is successful' do
      before do
        allow(service).to receive(:process_invite).and_return(instance_double('Result', message: 'Invite sent successfully.', data: {}))
        post :process_invite, params: { email: email }, format: :json
      end

      it 'returns a success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct message' do
        expect(JSON.parse(response.body)['message']).to eq('Invite sent successfully.')
      end
    end

    context 'when invite fails' do
      before do
        allow(service).to receive(:process_invite).and_raise(stytch_error)
        post :process_invite, params: { email: email }, format: :json
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST #process_revoke_invite' do
    context 'when revoke invite is successful' do
      before do
        allow(service).to receive(:process_revoke_invite).and_return(instance_double('Result', message: 'Invite revoked successfully.', data: {}))
        post :process_revoke_invite, params: { email: email }, format: :json
      end

      it 'returns a success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct message' do
        expect(JSON.parse(response.body)['message']).to eq('Invite revoked successfully.')
      end
    end

    context 'when revoke invite fails' do
      before do
        allow(service).to receive(:process_revoke_invite).and_raise(stytch_error)
        post :process_revoke_invite, params: { email: email }, format: :json
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST #process_authenticate' do
    context 'when authentication is successful' do
      before do
        allow(service).to receive(:process_authenticate).and_return(instance_double('Result', message: 'Authentication successful.', data: { 'user_id' => 'user_123' }))
        post :process_authenticate, params: { token: token }, format: :json
      end

      it 'returns a success status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct user_id' do
        expect(JSON.parse(response.body)['data']['user_id']).to eq('user_123')
      end
    end

    context 'when authentication fails' do
      before do
        allow(service).to receive(:process_authenticate).and_raise(stytch_error)
        post :process_authenticate, params: { token: token }, format: :json
      end

      it 'returns a bad request status' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
