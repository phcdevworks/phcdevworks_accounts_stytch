require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::Success do
  describe '#initialize' do
    it 'sets the attributes correctly' do
      success = described_class.new(
        status_code: 200,
        message: 'Request successful',
        data: { 'key' => 'value' }
      )

      expect(success.status_code).to eq(200)
      expect(success.message).to eq('Request successful')
      expect(success.data).to eq({ 'key' => 'value' })
    end

    it 'serializes to a hash correctly' do
      success = described_class.new(
        status_code: 200,
        message: 'Request successful',
        data: { 'key' => 'value' }
      )

      expect(success.to_h).to eq(
        {
          status_code: 200,
          message: 'Request successful',
          data: { 'key' => 'value' }
        }
      )
    end
  end
end
