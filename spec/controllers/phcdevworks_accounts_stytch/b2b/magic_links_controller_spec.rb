require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::MagicLinksController, type: :controller do
  routes { PhcdevworksAccountsStytch::Engine.routes }

  let(:organization_id) { 'org_123' }
  let(:email) { 'user@example.com' }
  let(:session_token) { 'valid_session_token' }
  let(:service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService) }

  before do
    allow(controller).to receive(:service).and_return(service)
    allow(controller).instance_variable_set(:@organization_id, organization_id)
  end

  describe 'POST #process_invite' do
    context 'when parameters are missing' do
      it 'returns an unprocessable entity status with detailed error' do
        allow(controller).to receive(:set_organization).and_return(nil)
        post :process_invite, params: { email: nil, session_token: nil }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Email, Organization Slug, and Session Token are required'
        )
      end

      it 'returns an unprocessable entity status with specific error for missing organization_slug' do
        post :process_invite, params: { email: 'user@example.com', session_token: 'valid_token' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Organization slug is required'
        )
      end
    end
  end

  describe 'POST #process_revoke_invite' do
    context 'when email is missing' do
      it 'returns an unprocessable entity status' do
        post :process_revoke_invite, params: { email: nil }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Email is required to revoke invite'
        )
      end
    end

    context 'when service raises an error' do
      before do
        allow(service).to receive(:process_revoke_invite).and_raise(
          PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: 404,
            error_code: 'invite_not_found',
            error_message: 'Invite not found'
          )
        )
      end

      it 'returns a not found status with error message' do
        post :process_revoke_invite, params: { email: 'nonexistent@example.com' }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Stytch Error (Status Code: 404) - Code: invite_not_found - Message: Invite not found',
          'code' => 'invite_not_found',
          'details' => {
            'cause' => nil,
            'error_code' => 'invite_not_found',
            'error_message' => 'Invite not found',
            'original_error' => nil,
            'status_code' => 404
          }
        )
      end
    end
  end
end
