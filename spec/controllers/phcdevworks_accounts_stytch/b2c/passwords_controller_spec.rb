# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2c::PasswordsController, type: :controller do
  routes { PhcdevworksAccountsStytch::Engine.routes }

  let(:service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2c::PasswordService) }
  let(:email) { 'user@example.com' }
  let(:token) { 'reset_token' }
  let(:password) { 'new_password' }
  let(:old_password) { 'old_password' }
  let(:session_token) { 'session_token' }

  before do
    allow(PhcdevworksAccountsStytch::Authentication::B2c::PasswordService).to receive(:new).and_return(service)
  end

  describe 'POST #process_reset_password' do
    context 'when missing required params' do
      before { post :process_reset_password, params: { token: '', password: '' } }

      it 'returns an error' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Token and Password are required.')
      end
    end

    context 'when reset is successful' do
      let(:success_response) do
        instance_double(PhcdevworksAccountsStytch::Stytch::Success, message: 'Action completed successfully',
                                                                    data: { key: 'value' })
      end

      before do
        allow(service).to receive(:reset).with(token, password).and_return(success_response)
        post :process_reset_password, params: { token: token, password: password }
      end

      it 'calls the reset service' do
        expect(service).to have_received(:reset).with(token, password)
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Action completed successfully')
      end
    end

    context 'when reset fails' do
      let(:error) { PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Reset error') }

      before do
        allow(service).to receive(:reset).with(token, password).and_raise(error)
        post :process_reset_password, params: { token: token, password: password }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Stytch Error (Status Code: 400) - Message: Reset error')
      end
    end
  end

  describe 'POST #process_reset_existing_password' do
    context 'when missing required params' do
      before do
        post :process_reset_existing_password,
             params: { email: '', old_password: '', new_password: '' }
      end

      it 'returns an error' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Email, old password, and new password are required.')
      end
    end

    context 'when reset existing is successful' do
      let(:success_response) do
        instance_double(PhcdevworksAccountsStytch::Stytch::Success, message: 'Action completed successfully',
                                                                    data: { key: 'value' })
      end

      before do
        allow(service).to receive(:reset_existing).with(email, old_password, password).and_return(success_response)
        post :process_reset_existing_password,
             params: { email: email, old_password: old_password, new_password: password }
      end

      it 'calls the reset_existing service' do
        expect(service).to have_received(:reset_existing).with(email, old_password, password)
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Action completed successfully')
      end
    end

    context 'when reset existing fails' do
      let(:error) { PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Reset existing error') }

      before do
        allow(service).to receive(:reset_existing).with(email, old_password, password).and_raise(error)
        post :process_reset_existing_password,
             params: { email: email, old_password: old_password, new_password: password }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Stytch Error (Status Code: 400) - Message: Reset existing error')
      end
    end
  end

  describe 'POST #process_reset_with_session' do
    context 'when missing required params' do
      before do
        post :process_reset_with_session, params: { session_token: '', password: '' }
      end

      it 'returns an error' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Session token and new password are required.')
      end
    end

    context 'when reset with session is successful' do
      let(:success_response) do
        instance_double(PhcdevworksAccountsStytch::Stytch::Success, message: 'Action completed successfully',
                                                                    data: { key: 'value' })
      end

      before do
        allow(service).to receive(:reset_with_session).with(session_token, password).and_return(success_response)
        post :process_reset_with_session,
             params: { session_token: session_token, password: password }
      end

      it 'calls the reset_with_session service' do
        expect(service).to have_received(:reset_with_session).with(session_token, password)
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Action completed successfully')
      end
    end

    context 'when reset with session fails' do
      let(:error) { PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Reset session error') }

      before do
        allow(service).to receive(:reset_with_session).with(session_token, password).and_raise(error)
        post :process_reset_with_session,
             params: { session_token: session_token, password: password }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Stytch Error (Status Code: 400) - Message: Reset session error')
      end
    end
  end

  describe 'POST #process_reset_start' do
    context 'when missing required params' do
      before do
        # Simulate a post request with missing email
        post :process_reset_start, params: { email: '' }
      end

      it 'returns an error when email is missing' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Email is required.')
      end
    end

    context 'when reset start is successful' do
      let(:success_response) do
        instance_double(PhcdevworksAccountsStytch::Stytch::Success, message: 'Action completed successfully',
                                                                    data: { key: 'value' })
      end

      before do
        allow(service).to receive(:reset_start).with(email).and_return(success_response)
        post :process_reset_start, params: { email: email }
      end

      it 'calls the reset_start service' do
        expect(service).to have_received(:reset_start).with(email)
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Action completed successfully')
      end
    end

    context 'when reset start fails' do
      let(:error) { PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Reset start error') }

      before do
        allow(service).to receive(:reset_start).with(email).and_raise(error)
        post :process_reset_start, params: { email: email }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Stytch Error (Status Code: 400) - Message: Reset start error')
      end
    end
  end
end
