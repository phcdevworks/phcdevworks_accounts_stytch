require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::Error do
  describe '#initialize' do
    it 'sets the error attributes correctly' do
      error = described_class.new(
        status_code: 401,
        error_code: 'authentication_error',
        error_message: 'Invalid token'
      )

      expect(error.status_code).to eq(401)
      expect(error.error_code).to eq('authentication_error')
      expect(error.error_message).to eq('Invalid token')
    end

    it 'serializes to a hash correctly' do
      error = described_class.new(
        status_code: 401,
        error_code: 'authentication_error',
        error_message: 'Invalid token'
      )

      expect(error.to_h).to eq(
        {
          status: 401,
          error_code: 'authentication_error',
          error_message: 'Invalid token'
        }
      )
    end
  end
end
