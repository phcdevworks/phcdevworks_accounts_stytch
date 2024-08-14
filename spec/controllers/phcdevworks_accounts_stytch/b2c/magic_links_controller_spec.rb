# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2c::MagicLinksController, type: :controller do
  routes { PhcdevworksAccountsStytch::Engine.routes }

  let(:email) { 'user@example.com' }
  let(:token) { 'some_valid_token' }
  let(:service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService) }

  before do
    allow(PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService).to receive(:new).and_return(service)
  end

  describe 'POST #login_or_create' do
    context 'when login or create is successful' do
      before do
        allow(service).to receive(:login_or_create).and_return({ 'user_id' => 'user_123' })
        post :login_or_create, params: { email: email }, format: :json
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['user_id']).to eq('user_123')
      end
    end

    context 'when login or create fails' do
      before do
        allow(service).to receive(:login_or_create).and_return(nil)
        post :login_or_create, params: { email: email }, format: :json
      end

      it 'returns an unprocessable entity response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #send_magic_link' do
    context 'when sending magic link is successful' do
      before do
        allow(service).to receive(:send_magic_link).and_return(true)
        post :send_magic_link, params: { email: email }, format: :json
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when sending magic link fails' do
      before do
        allow(service).to receive(:send_magic_link).and_return(nil)
        post :send_magic_link, params: { email: email }, format: :json
      end

      it 'returns an unprocessable entity response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #invite' do
    context 'when invite is successful' do
      before do
        allow(service).to receive(:invite).and_return(true)
        post :invite, params: { email: email }, format: :json
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when invite fails' do
      before do
        allow(service).to receive(:invite).and_return(nil)
        post :invite, params: { email: email }, format: :json
      end

      it 'returns an unprocessable entity response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #revoke_invite' do
    context 'when revoke invite is successful' do
      before do
        allow(service).to receive(:revoke_invite).and_return(true)
        post :revoke_invite, params: { email: email }, format: :json
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when revoke invite fails' do
      before do
        allow(service).to receive(:revoke_invite).and_return(nil)
        post :revoke_invite, params: { email: email }, format: :json
      end

      it 'returns an unprocessable entity response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #authenticate' do
    context 'when authentication is successful' do
      before do
        allow(service).to receive(:authenticate).and_return({ 'user_id' => 'user_123' })
        post :authenticate, params: { token: token }, format: :json
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['user_id']).to eq('user_123')
      end
    end

    context 'when authentication fails' do
      before do
        allow(service).to receive(:authenticate).and_return(nil)
        post :authenticate, params: { token: token }, format: :json
      end

      it 'returns an unprocessable entity response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
