# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2c::MagicLinksController, type: :controller do
  routes { PhcdevworksAccountsStytch::Engine.routes }

  let(:service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService) }
  let(:email) { 'user@example.com' }

  before do
    allow(PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService).to receive(:new).and_return(service)
  end

  describe 'POST #process_login_or_signup' do
    context 'when login or signup is successful' do
      let(:success_response) do
        instance_double(PhcdevworksAccountsStytch::Stytch::Success, message: 'Success', data: { 'user_id' => 'user_123' })
      end

      before do
        allow(service).to receive(:process_login_or_signup).with(email).and_return(success_response)
        post :process_login_or_signup, params: { email: email }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message' => 'Success', 'data' => { 'user_id' => 'user_123' })
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
    context 'when invite is successful' do
      let(:success_response) do
        instance_double(PhcdevworksAccountsStytch::Stytch::Success, message: 'Invite sent successfully.', data: {})
      end

      before do
        allow(service).to receive(:process_invite).with(email).and_return(success_response)
        post :process_invite, params: { email: email }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message' => 'Invite sent successfully.')
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
        expect(JSON.parse(response.body)).to include('error' => 'Stytch Error (Status Code: 400) - Message: Invite error')
      end
    end
  end

  describe 'POST #process_revoke_invite' do
    context 'when revoke invite is successful' do
      let(:success_response) do
        instance_double(PhcdevworksAccountsStytch::Stytch::Success, message: 'Invite revoked successfully.', data: {})
      end

      before do
        allow(service).to receive(:process_revoke_invite).with(email).and_return(success_response)
        post :process_revoke_invite, params: { email: email }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message' => 'Invite revoked successfully.')
      end
    end

    context 'when revoke invite fails' do
      let(:error) { PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Revoke invite error') }

      before do
        allow(service).to receive(:process_revoke_invite).with(email).and_raise(error)
        post :process_revoke_invite, params: { email: email }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body))
          .to include('error' => 'Stytch Error (Status Code: 400) - Message: Revoke invite error')
      end
    end
  end
end
