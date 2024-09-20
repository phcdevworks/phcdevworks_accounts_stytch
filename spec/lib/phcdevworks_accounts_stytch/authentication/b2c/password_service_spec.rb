# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Authentication::B2c::PasswordService do
  let(:client) { instance_double(Stytch::Client) }
  let(:passwords) { instance_double(Stytch::Passwords) }
  let(:passwords_email) { instance_double(Stytch::Passwords::Email) }
  let(:passwords_existing) { instance_double(Stytch::Passwords::ExistingPassword) }
  let(:passwords_sessions) { instance_double(Stytch::Passwords::Sessions) }
  let(:email) { 'user@example.com' }
  let(:password_reset_token) { 'reset_token' }
  let(:new_password) { 'new_secure_password' }
  let(:old_password) { 'old_secure_password' }
  let(:session_token) { 'some_session_token' }
  let(:password) { 'secure_password' }
  let(:service) { described_class.new }

  before do
    allow(client).to receive(:passwords).and_return(passwords)
    allow(passwords).to receive_messages(
      email: passwords_email,
      existing_password: passwords_existing,
      sessions: passwords_sessions
    )
    allow(PhcdevworksAccountsStytch::Stytch::Client).to receive(:b2c_client).and_return(client)
  end

  describe '#reset_start' do
    context 'when reset start is successful' do
      it 'returns a Success object' do
        response = successful_response
        allow_successful_reset_start(response)

        result = service.reset_start(email)

        expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
        expect(result.status_code).to eq(200)
        expect(result.data).to eq(response)
      end
    end

    context 'when reset start fails' do
      it 'raises a custom error' do
        allow_failed_reset_start

        expect do
          service.reset_start(email)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error,
                           'Stytch Error (Status Code: 400) - Code: some_error_code - Message: Reset start error')
      end
    end
  end

  describe '#reset' do
    context 'when reset is successful' do
      it 'returns a Success object' do
        response = successful_response
        allow_successful_reset(response)

        result = service.reset(password_reset_token, new_password)

        expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
        expect(result.status_code).to eq(200)
        expect(result.data).to eq(response)
      end
    end

    context 'when reset fails' do
      it 'raises a custom error' do
        allow_failed_reset

        expect do
          service.reset(password_reset_token, new_password)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error,
                           'Stytch Error (Status Code: 400) - Code: reset_error - Message: Reset error')
      end
    end
  end

  describe '#reset_existing' do
    context 'when reset existing is successful' do
      it 'returns a Success object' do
        response = successful_response
        allow_successful_reset_existing(response)

        result = service.reset_existing(email, old_password, new_password)

        expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
        expect(result.status_code).to eq(200)
        expect(result.data).to eq(response)
      end
    end

    context 'when reset existing fails' do
      it 'raises a custom error' do
        allow_failed_reset_existing

        expect do
          service.reset_existing(email, old_password, new_password)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error,
                           'Stytch Error (Status Code: 400) - Code: existing_reset_error - Message: Existing reset error')
      end
    end
  end

  describe '#reset_with_session' do
    context 'when reset with session is successful' do
      it 'returns a Success object' do
        response = successful_response
        allow_successful_reset_with_session(response)

        result = service.reset_with_session(session_token, new_password)

        expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
        expect(result.status_code).to eq(200)
        expect(result.data).to eq(response)
      end
    end

    context 'when reset with session fails' do
      it 'raises a custom error' do
        allow_failed_reset_with_session

        expect do
          service.reset_with_session(session_token, new_password)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error,
                           'Stytch Error (Status Code: 400) - Code: session_reset_error - Message: Session reset error')
      end
    end
  end

  describe '#authenticate_password' do
    context 'when authentication is successful' do
      it 'returns a Success object' do
        response = successful_response
        allow_successful_authenticate(response)

        result = service.authenticate_password(email, password)

        expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
        expect(result.status_code).to eq(200)
        expect(result.data).to eq(response)
      end
    end

    context 'when authentication fails' do
      it 'raises a custom error' do
        allow_failed_authenticate

        expect do
          service.authenticate_password(email, password)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error,
                           'Stytch Error (Status Code: 401) - Code: authentication_error - Message: Authentication failed')
      end
    end
  end

  private

  def successful_response
    { http_status_code: 200, user_id: 'user_123', session_token: 'session_123' }
  end

  def allow_successful_reset_start(response)
    allow(passwords_email).to receive(:reset_start).with(email: email).and_return(response)
  end

  def allow_failed_reset_start
    response = { http_status_code: 400, stytch_api_error: { error_type: 'some_error_code', error_message: 'Reset start error' } }
    allow(passwords_email).to receive(:reset_start).with(email: email).and_return(response)
  end

  def allow_successful_reset(response)
    allow(passwords_email).to receive(:reset).with(token: password_reset_token, password: new_password).and_return(response)
  end

  def allow_failed_reset
    response = { http_status_code: 400, stytch_api_error: { error_type: 'reset_error', error_message: 'Reset error' } }
    allow(passwords_email).to receive(:reset).with(token: password_reset_token, password: new_password).and_return(response)
  end

  def allow_successful_reset_existing(response)
    allow(passwords_existing).to receive(:reset).with(email: email, existing_password: old_password,
                                                      new_password: new_password).and_return(response)
  end

  def allow_failed_reset_existing
    response = { http_status_code: 400,
                 stytch_api_error: { error_type: 'existing_reset_error', error_message: 'Existing reset error' } }
    allow(passwords_existing).to receive(:reset).with(email: email, existing_password: old_password,
                                                      new_password: new_password).and_return(response)
  end

  def allow_successful_reset_with_session(response)
    allow(passwords_sessions).to receive(:reset).with(session_token: session_token, password: new_password).and_return(response)
  end

  def allow_failed_reset_with_session
    response = { http_status_code: 400,
                 stytch_api_error: { error_type: 'session_reset_error', error_message: 'Session reset error' } }
    allow(passwords_sessions).to receive(:reset).with(session_token: session_token, password: new_password).and_return(response)
  end

  def allow_successful_authenticate(response)
    allow(passwords).to receive(:authenticate).with(email: email, password: password).and_return(response)
  end

  def allow_failed_authenticate
    response = { http_status_code: 401,
                 stytch_api_error: { error_type: 'authentication_error', error_message: 'Authentication failed' } }
    allow(passwords).to receive(:authenticate).with(email: email, password: password).and_return(response)
  end
end
