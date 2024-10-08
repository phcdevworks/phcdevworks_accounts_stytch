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
    context 'when required params are missing' do
      before do
        post :process_login_or_signup, params: { email: '', organization_slug: '' }
      end

      it 'returns an error when email and organization_slug are missing' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include(
          'error' => 'Organization slug is required'
        )
      end
    end

    context 'when only organization_slug is missing' do
      before do
        post :process_login_or_signup, params: { email: email, organization_slug: '' }
      end

      it 'returns an error when organization_slug is missing' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include(
          'error' => 'Organization slug is required'
        )
      end
    end

    context 'when login or signup is successful' do
      let(:success_response) do
        instance_double(
          PhcdevworksAccountsStytch::Stytch::Success, message: 'Action completed successfully', data: { key: 'value' }
        )
      end

      before do
        allow(service).to receive(:process_login_or_signup).with(email, organization_id).and_return(success_response)
        post :process_login_or_signup, params: { email: email, organization_slug: organization_slug }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include(
          'message' => 'Action completed successfully'
        )
      end
    end

    context 'when login or signup fails' do
      let(:error) { PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Login error') }

      before do
        allow(service).to receive(:process_login_or_signup).with(email, organization_id).and_raise(error)
        post :process_login_or_signup, params: { email: email, organization_slug: organization_slug }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include(
          'error' => 'Stytch Error (Status Code: 400) - Message: Login error'
        )
      end

      context 'when email format is invalid' do
        let(:error) { PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 422, error_message: 'Invalid email format.') }

        before do
          allow(service).to receive(:process_login_or_signup).with('invalid-email', organization_id).and_raise(error)
          post :process_login_or_signup, params: { email: 'invalid-email', organization_slug: organization_slug }
        end

        it 'returns an error response for invalid email format' do
          expect(response).to have_http_status(:bad_request)
          expect(JSON.parse(response.body)).to include(
            'error' => 'Stytch Error (Status Code: 422) - Message: Invalid email format.'
          )
        end
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
        expect(JSON.parse(response.body)).to include('error' => 'Email and Organization Slug are required.')
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
        expect(JSON.parse(response.body))
          .to include('error' => 'Stytch Error (Status Code: 400) - Message: Invite error')
      end
    end
  end
end
