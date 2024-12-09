# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::MagicLinksController, type: :controller do
  routes { PhcdevworksAccountsStytch::Engine.routes }

  let(:service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService) }
  let(:email) { 'user@example.com' }
  let(:organization_slug) { 'example-org' }
  let(:organization_id) { 'org_123' }
  let(:session_token) { 'some_session_token' }
  let(:organization_service) { instance_double(PhcdevworksAccountsStytch::Stytch::Organization) }

  before do
    allow(PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService).to receive(:new).and_return(service)
    allow(PhcdevworksAccountsStytch::Stytch::Organization).to receive(:new).and_return(organization_service)
    allow(organization_service).to receive(:find_organization_id_by_slug).with(organization_slug).and_return(organization_id)
    allow(organization_service).to receive(:find_organization_id_by_slug).with('').and_return(nil)
  end

  describe 'POST #process_login_or_signup' do
    context 'when missing_login_or_signup_params? returns true' do
      before do
        allow(controller).to receive(:missing_login_or_signup_params?).and_return(true)
        allow(controller).to receive(:handle_missing_params_error)
        allow(controller).to receive(:set_organization)
        # Add stub for process_login_or_signup
        allow(service).to receive(:process_login_or_signup)
        post :process_login_or_signup, params: { email: '', organization_slug: '' }
      end

      it 'calls handle_missing_params_error and returns early' do
        expect(controller).to have_received(:handle_missing_params_error).with('Organization slug is required')
        expect(service).not_to have_received(:process_login_or_signup)
      end
    end

    context 'when missing_login_or_signup_params? returns false' do
      let(:result) { instance_double(PhcdevworksAccountsStytch::Stytch::Success, data: { key: 'value' }) }

      before do
        allow(controller).to receive(:missing_login_or_signup_params?).and_return(false)
        allow(service).to receive(:process_login_or_signup).with(email, organization_id).and_return(result)
        allow(Rails.logger).to receive(:info)
        post :process_login_or_signup, params: { email: email, organization_slug: organization_slug }
      end

      it 'processes the login or signup request' do
        expect(service).to have_received(:process_login_or_signup).with(email, organization_id)
        expect(Rails.logger).to have_received(:info).with("Login or Signup successful: #{result.data}")
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST #process_invite' do
    context 'when email or organization_slug is missing' do
      before do
        post :process_invite, params: { email: '', organization_slug: 'example-org' }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when invite is successful' do
      let(:success_response) do
        instance_double(
          PhcdevworksAccountsStytch::Stytch::Success, message: 'Action completed successfully', data: { key: 'value' }
        )
      end

      before do
        allow(service).to receive(:process_invite).with(email, organization_id, session_token).and_return(success_response)
        post :process_invite, params: { email: email, organization_slug: organization_slug, session_token: session_token }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message' => 'Action completed successfully')
      end
    end

    context 'when invite fails' do
      let(:error) { PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Invite error') }

      before do
        allow(service).to receive(:process_invite).with(email, organization_id, session_token).and_raise(error)
        post :process_invite, params: { email: email, organization_slug: organization_slug, session_token: session_token }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include('error' => 'Stytch Error (Status Code: 400) - Message: Invite error')
      end
    end
  end

  describe '#missing_login_or_signup_params?' do
    before do
      allow(controller).to receive(:params).and_return(params_hash)
    end

    context 'when email is blank' do
      let(:params_hash) { { email: '' } }

      before do
        controller.instance_variable_set(:@organization_id, 'org_123')
      end

      it 'returns true' do
        expect(controller.send(:missing_login_or_signup_params?)).to be true
      end
    end

    context 'when organization_id is blank' do
      let(:params_hash) { { email: 'test@example.com' } }

      before do
        controller.instance_variable_set(:@organization_id, nil)
      end

      it 'returns true' do
        expect(controller.send(:missing_login_or_signup_params?)).to be true
      end
    end

    context 'when both email and organization_id are present' do
      let(:params_hash) { { email: 'test@example.com' } }

      before do
        controller.instance_variable_set(:@organization_id, 'org_123')
      end

      it 'returns false' do
        expect(controller.send(:missing_login_or_signup_params?)).to be false
      end
    end
  end
end
