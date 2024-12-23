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
    Rails.logger.info "Setup complete for: #{described_class.name}"
  end

  describe 'POST #process_invite' do
    context 'when parameters are missing' do
      it 'returns an unprocessable entity status with detailed error' do
        Rails.logger.info 'Running test: Missing parameters for process_invite'
        allow(controller).to receive(:set_organization).and_return(nil) # Simulate missing slug
        post :process_invite, params: { email: nil, session_token: nil }
        Rails.logger.debug "Response: #{response.body}, Status: #{response.status}"

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Email, Organization Slug, and Session Token are required'
        )
      end

      it 'returns an unprocessable entity status with specific error for missing organization_slug' do
        Rails.logger.info 'Running test: Missing organization_slug for process_invite'
        allow(controller).to receive(:set_organization).and_return(nil)
        post :process_invite, params: { email: 'user@example.com', session_token: 'valid_token' }
        Rails.logger.debug "Response: #{response.body}, Status: #{response.status}"

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Organization Slug is required'
        )
      end
    end
  end

  describe 'POST #process_revoke_invite' do
    context 'when email is missing' do
      it 'returns an unprocessable entity status' do
        Rails.logger.info 'Running test: Missing email for process_revoke_invite'
        allow(controller).to receive(:set_organization).and_return(nil)
        post :process_revoke_invite, params: { email: nil }
        Rails.logger.debug "Response: #{response.body}, Status: #{response.status}"

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Email is required to revoke invite'
        )
      end
    end

    context 'when service raises an error' do
      before do
        Rails.logger.info 'Setting up: Simulating Stytch::Error for process_revoke_invite'
        allow(service).to receive(:process_revoke_invite).and_raise(
          PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: 404,
            error_code: 'invite_not_found',
            error_message: 'Invite not found',
            cause: nil,
            original_error: nil
          )
        )
      end

      it 'returns a not found status with error message' do
        Rails.logger.info 'Running test: Simulated Stytch::Error for process_revoke_invite'
        post :process_revoke_invite, params: { email: 'nonexistent@example.com' }
        Rails.logger.debug "Response: #{response.body}, Status: #{response.status}"

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq(
          'error' => 'Stytch Error (Status Code: 404) - Code: invite_not_found - Message: Invite not found',
          'code' => 'invite_not_found',
          'details' => {
            'status_code' => 404,
            'error_code' => 'invite_not_found',
            'error_message' => 'Invite not found',
            'cause' => nil,
            'original_error' => nil
          }
        )
      end
    end

    context 'when an unexpected error occurs' do
      before do
        Rails.logger.info 'Setting up: Simulating unexpected error for process_revoke_invite'
        allow(service).to receive(:process_revoke_invite).and_raise(
          StandardError.new('Unexpected failure')
        )
      end

      it 'returns an internal server error status with generic error message' do
        Rails.logger.info 'Running test: Simulated unexpected error for process_revoke_invite'
        post :process_revoke_invite, params: { email: 'nonexistent@example.com' }
        Rails.logger.debug "Response: #{response.body}, Status: #{response.status}"

        expected_response = { 'error' => 'An unexpected error occurred.' }
        expected_response['details'] = 'Unexpected failure' if Rails.env.development?

        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end
  end
end
