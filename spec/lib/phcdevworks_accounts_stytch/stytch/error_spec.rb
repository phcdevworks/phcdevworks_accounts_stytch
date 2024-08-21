# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::Error do
  describe '#initialize' do
    it 'when all attributes are provided builds the correct error message' do
      error = described_class.new(status_code: 400, error_code: 'invalid_request', error_message: 'Invalid request')
      expect(error.message).to eq('Stytch Error (Status Code: 400) - Code: invalid_request - Message: Invalid request')
    end

    it 'when error_message is not provided builds the correct error message with default error message' do
      error = described_class.new(status_code: 500, error_code: 'server_error')
      expect(error.message).to eq('Stytch Error (Status Code: 500) - Code: server_error - Message: An error occurred with Stytch')
    end
  end

  describe '#build_message' do
    it 'constructs the error message correctly based on the attributes provided' do
      error = described_class.new(status_code: 400, error_code: 'bad_request', error_message: 'Bad request error')
      expect(error.send(:build_message)).to eq('Stytch Error (Status Code: 400) - Code: bad_request - Message: Bad request error')
    end
  end
end
