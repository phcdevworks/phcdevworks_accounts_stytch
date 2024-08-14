# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::MagicLinksController, type: :controller do
  routes { PhcdevworksAccountsStytch::Engine.routes }

  let(:email) { 'user@example.com' }
  let(:organization_id) { 'org_123' }
  let(:token) { 'some_valid_token' }
  let(:service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService) }

  before do
    allow(PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService).to receive(:new).and_return(service)
  end

  describe 'POST #invite' do
    context 'when invite is successful' do
      before do
        allow(service).to receive(:invite).and_return(true)
        post :invite, params: { email: email, organization_id: organization_id }, format: :json
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when invite fails' do
      before do
        allow(service).to receive(:invite).and_return(nil)
        post :invite, params: { email: email, organization_id: organization_id }, format: :json
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
