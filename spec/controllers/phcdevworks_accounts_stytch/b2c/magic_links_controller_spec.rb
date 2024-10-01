# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2c::MagicLinksController, type: :controller do
  routes { PhcdevworksAccountsStytch::Engine.routes }

  let(:service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService) }
  let(:email) { 'user@example.com' }

  before do
    allow(PhcdevworksAccountsStytch::Authentication::B2c::MagicLinkService).to receive(:new).and_return(service)
  end

  # Process Login or Signup test
  describe 'POST #process_login_or_signup' do
    context 'when email is missing' do
      before do
        post :process_login_or_signup, params: { email: '' }
      end

      it 'returns an error when email is missing' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => 'Email is required.')
      end
    end

    context 'when login or signup is successful' do
      before do
        success_response = { message: 'Login or Signup successful', data: { key: 'value' } }
        allow(service).to receive(:process_login_or_signup).with(email).and_return(success_response)

        post :process_login_or_signup, params: { email: email }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message' => 'Login or Signup successful')
      end
    end

    context 'when login or signup fails due to API error' do
      before do
        error = PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Login error')
        allow(service).to receive(:process_login_or_signup).with(email).and_raise(error)

        post :process_login_or_signup, params: { email: email }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include(
          'error' => 'Stytch Error (Status Code: 400) - Message: Login error'
        )
      end
    end

    context 'when an unexpected error occurs' do
      before do
        allow(service).to receive(:process_login_or_signup).with(email).and_raise(StandardError.new('Unexpected error'))

        post :process_login_or_signup, params: { email: email }
      end

      it 'returns a 500 error response' do
        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)).to include(
          'error' => 'An unexpected error occurred.'
        )
      end
    end
  end

  # Process Invite test
  describe 'POST #process_invite' do
    context 'when email is missing' do
      before do
        post :process_invite, params: { email: '' }
      end

      it 'returns an error when email is missing' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include(
          'error' => 'Email is required.'
        )
      end
    end

    context 'when invite is successful' do
      before do
        success_response = { message: 'Invite successful', data: { key: 'value' } }
        allow(service).to receive(:process_invite).with(email).and_return(success_response)

        post :process_invite, params: { email: email }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include(
          'message' => 'Invite successful'
        )
      end
    end

    context 'when invite fails due to API error' do
      before do
        error = PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: 400, error_message: 'Stytch Error (Status Code: 400) - Message: Invite error'
        )
        allow(service).to receive(:process_invite).with(email).and_raise(error)

        post :process_invite, params: { email: email }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include(
          'error' => 'Stytch Error (Status Code: 400) - Message: Stytch Error (Status Code: 400) - Message: Invite error'
        ) # needs to be fixed
      end
    end

    context 'when an unexpected error occurs' do
      before do
        allow(service).to receive(:process_invite).with(email).and_raise(StandardError.new('Unexpected error'))

        post :process_invite, params: { email: email }
      end

      it 'returns a 500 error response' do
        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)).to include(
          'error' => 'An unexpected error occurred.'
        )
      end
    end
  end

  # Process Revoke Invite test
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
        allow(service).to receive(:process_revoke_invite).with(email).and_return(success_response)

        # Create a mock logger specifically for this test
        @mock_logger = double('logger')
        allow(@mock_logger).to receive(:info)
        allow(Rails).to receive(:logger).and_return(@mock_logger)
      end

      it 'logs the success message' do
        expect(@mock_logger).to receive(:info).with('Revoke invite successful: Invite revoked successfully')

        post :process_revoke_invite, params: { email: email }
      end

      it 'returns a success response' do
        post :process_revoke_invite, params: { email: email }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include('message' => 'Invite revoked successfully')
      end
    end

    context 'when revoke invite fails due to API error' do
      before do
        error = PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Revoke error')
        allow(service).to receive(:process_revoke_invite).with(email).and_raise(error)

        post :process_revoke_invite, params: { email: email }
      end

      it 'returns an API error response' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to include('error' => 'Stytch Error (Status Code: 400) - Message: Revoke error')
      end
    end

    context 'when an unexpected error occurs' do
      before do
        allow(service).to receive(:process_revoke_invite).with(email).and_raise(StandardError.new('Unexpected error'))

        post :process_revoke_invite, params: { email: email }
      end

      it 'returns a 500 error response' do
        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)).to include('error' => 'An unexpected error occurred.')
      end
    end
  end
end
