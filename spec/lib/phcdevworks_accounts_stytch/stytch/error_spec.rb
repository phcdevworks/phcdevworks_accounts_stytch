require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::Error do
  let(:default_status_code) { 500 }
  let(:default_error_code) { 'unknown_error' }
  let(:default_error_message) { 'An unknown error occurred' }
  let(:custom_cause) { StandardError.new("Some cause message") }
  let(:original_error) { StandardError.new("Original error message") }

  describe '#initialize' do
    context 'when initialized with default values' do
      subject { described_class.new }

      it 'sets the default status_code' do
        expect(subject.status_code).to eq(default_status_code)
      end

      it 'sets the default error_code' do
        expect(subject.error_code).to eq(default_error_code)
      end

      it 'sets the default error_message' do
        expect(subject.error_message).to eq(default_error_message)
      end

      it 'logs the error message' do
        expect(Rails.logger).to receive(:error).with(/Stytch Error/)
        described_class.new
      end
    end

    context 'when initialized with custom values' do
      subject do
        described_class.new(
          status_code: 400,
          error_code: 'custom_error',
          error_message: 'Custom error occurred',
          cause: custom_cause,
          original_error: original_error
        )
      end

      it 'sets the provided status_code' do
        expect(subject.status_code).to eq(400)
      end

      it 'sets the provided error_code' do
        expect(subject.error_code).to eq('custom_error')
      end

      it 'sets the provided error_message' do
        expect(subject.error_message).to eq('Custom error occurred')
      end

      it 'sets the provided cause' do
        expect(subject.cause).to eq(custom_cause)
      end

      it 'sets the provided original_error' do
        expect(subject.original_error).to eq(original_error)
      end
    end
  end

  describe '.from_stytch_error' do
    let(:stytch_error) { double('StytchError', status_code: 401, error_code: 'unauthorized', message: 'Unauthorized') }

    subject { described_class.from_stytch_error(stytch_error) }

    it 'creates a new error with the status_code from the stytch error' do
      expect(subject.status_code).to eq(401)
    end

    it 'creates a new error with the error_code from the stytch error' do
      expect(subject.error_code).to eq('unauthorized')
    end

    it 'creates a new error with the message from the stytch error' do
      expect(subject.error_message).to eq('Unauthorized')
    end

    it 'sets the original error' do
      expect(subject.original_error).to eq(stytch_error)
    end
  end

  describe '#to_h' do
    subject do
      described_class.new(
        status_code: 404,
        error_code: 'not_found',
        error_message: 'Resource not found',
        cause: custom_cause,
        original_error: original_error
      )
    end

    it 'returns a hash representation of the error' do
      expect(subject.to_h).to eq(
        status_code: 404,
        error_code: 'not_found',
        error_message: 'Resource not found',
        cause: 'Some cause message',
        original_error: {
          class: 'StandardError',
          message: 'Original error message',
          backtrace: original_error.backtrace&.first(5)
        }
      )
    end
  end

  describe '#to_json' do
    subject do
      described_class.new(
        status_code: 404,
        error_code: 'not_found',
        error_message: 'Resource not found',
        cause: custom_cause,
        original_error: original_error
      )
    end

    it 'returns a JSON representation of the error' do
      expect(JSON.parse(subject.to_json)).to eq(
        'status_code' => 404,
        'error_code' => 'not_found',
        'error_message' => 'Resource not found',
        'cause' => 'Some cause message',
        'original_error' => {
          'class' => 'StandardError',
          'message' => 'Original error message',
          'backtrace' => original_error.backtrace&.first(5)
        }
      )
    end
  end
end
