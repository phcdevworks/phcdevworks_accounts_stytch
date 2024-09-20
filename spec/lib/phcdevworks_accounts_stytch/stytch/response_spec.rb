# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::Response do
  describe '.handle_response' do
    let(:success_response) do
      {
        http_status_code: 200,
        email_address: 'user@example.com',
        data: { key: 'value' }
      }
    end

    let(:partial_success_response) do
      {
        http_status_code: 201,
        email_address: 'user@example.com',
        data: { key: 'value' }
      }
    end

    let(:error_response) do
      {
        http_status_code: 400,
        stytch_api_error: {
          error_type: 'invalid_request',
          error_message: 'The request was invalid'
        }
      }
    end

    let(:unknown_error_response) do
      {
        http_status_code: 500,
        stytch_api_error: {
          error_type: nil,
          error_message: nil
        }
      }
    end

    let(:internal_server_error_response) do
      {
        http_status_code: 500,
        stytch_api_error: {
          error_type: 'server_error',
          error_message: 'Internal server error'
        }
      }
    end

    let(:incomplete_response) do
      {
        data: { key: 'value' } # No http_status_code provided
      }
    end

    let(:malformed_response) { '{"invalid_json": ' } # Simulated malformed JSON

    context 'when the response is a success' do
      it 'returns a Success object for a 200 status code' do
        result = described_class.handle_response(success_response)

        expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
        expect(result.status_code).to eq(200)
        expect(result.message).to eq('Successfully invited user@example.com.')
        expect(result.data).to eq(success_response)
      end

      it 'returns a Success object for a 2xx status code' do
        result = described_class.handle_response(partial_success_response)

        expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
        expect(result.status_code).to eq(201)
        expect(result.message).to eq('Successfully invited user@example.com.')
        expect(result.data).to eq(partial_success_response)
      end
    end

    context 'when the response is an error' do
      it 'raises an error for a 400 status code with known error' do
        expect do
          described_class.handle_response(error_response)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error) do |e|
          expect(e.status_code).to eq(400)
          expect(e.error_code).to eq('invalid_request')
          expect(e.error_message).to eq('The request was invalid')
        end
      end

      it 'raises an error for a 500 status code with unknown error' do
        expect do
          described_class.handle_response(unknown_error_response)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error) do |e|
          expect(e.status_code).to eq(500)
          expect(e.error_code).to eq('unknown_error')
          expect(e.error_message).to eq('An unknown error occurred')
        end
      end

      it 'raises an error for a 500 status code with known error' do
        expect do
          described_class.handle_response(internal_server_error_response)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error) do |e|
          expect(e.status_code).to eq(500)
          expect(e.error_code).to eq('server_error')
          expect(e.error_message).to eq('Internal server error')
        end
      end
    end

    context 'when the response is missing http_status_code' do
      it 'defaults to 500 if status code is missing' do
        expect do
          described_class.handle_response(incomplete_response)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error) do |e|
          expect(e.status_code).to eq(500)
          expect(e.error_code).to eq('unknown_error')
          expect(e.error_message).to eq('An unknown error occurred')
        end
      end
    end

    context 'when the response is malformed or invalid' do
      it 'raises an error for malformed JSON response' do
        expect do
          described_class.handle_response(JSON.parse(malformed_response))
        end.to raise_error(JSON::ParserError)
      end
    end
  end
end
