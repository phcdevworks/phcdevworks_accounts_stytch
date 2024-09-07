# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2c::PasswordsController, type: :controller do
  let(:email) { 'user@example.com' }
  let(:password) { 'securepassword' }
  let(:service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2c::PasswordService) }

  before do
    allow(PhcdevworksAccountsStytch::Authentication::B2c::PasswordService).to receive(:new).and_return(service)
    @routes = PhcdevworksAccountsStytch::Engine.routes
  end

  describe 'POST #authenticate' do
    context 'when email and password are provided' do
      it 'redirects to the process_authenticate path' do
        post :authenticate, params: { email: email, password: password }

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(b2c_passwords_process_authenticate_path(email: email, password: password))
      end
    end

    context 'when email or password is missing' do
      it 'returns an error when email is missing' do
        post :authenticate, params: { email: '', password: password }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Email and password are required.')
      end

      it 'returns an error when password is missing' do
        post :authenticate, params: { email: email, password: '' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Email and password are required.')
      end
    end
  end

  describe 'POST #process_authenticate' do
    context 'when successful' do
      it 'authenticates the user and returns success' do
        allow(service).to receive(:authenticate_password).with(email, password).and_return({ message: 'Success', data: {} })

        post :process_authenticate, params: { email: email, password: password }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Success')
      end
    end

    context 'when email or password is missing' do
      it 'returns an error when email is missing' do
        post :process_authenticate, params: { email: '', password: password }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Email and password are required.')
      end

      it 'returns an error when password is missing' do
        post :process_authenticate, params: { email: email, password: '' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Email and password are required.')
      end
    end

    context 'when the Stytch service raises an error' do
      it 'returns a bad request when a Stytch::Error is raised' do
        allow(service).to receive(:authenticate_password).and_raise(PhcdevworksAccountsStytch::Stytch::Error.new(error_message: 'Invalid credentials'))

        post :process_authenticate, params: { email: email, password: password }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Stytch Error - Message: Invalid credentials')
      end
    end

    context 'when an unexpected error occurs' do
      it 'returns an internal server error' do
        allow(service).to receive(:authenticate_password).and_raise(StandardError.new('Unexpected error'))

        post :process_authenticate, params: { email: email, password: password }

        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)['error']).to eq('An unexpected error occurred.')
      end
    end
  end
end
