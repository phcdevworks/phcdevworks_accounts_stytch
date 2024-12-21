require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::Success do
  describe '#initialize' do
    context 'when initialized with valid status code' do
      let(:success) { described_class.new(status_code: 200, message: 'Operation successful', data: { key: 'value' }) }

      it 'sets the status_code, message, and data attributes' do
        expect(success.status_code).to eq(200)
        expect(success.message).to eq('Operation successful')
        expect(success.data).to eq({ key: 'value' })
      end
    end

    context 'when initialized with an invalid status code' do
      it 'raises an ArgumentError' do
        expect {
          described_class.new(status_code: 400)
        }.to raise_error(ArgumentError, 'Invalid status code for success: 400')
      end
    end

    it 'logs the success message if Rails is defined' do
      allow(Rails.logger).to receive(:info)
      described_class.new(status_code: 201, message: 'Created successfully', data: { id: 123 })
      expect(Rails.logger).to have_received(:info).with('Success: Created successfully (Status Code: 201, Data: {:id=>123})')
    end
  end

  describe '#success?' do
    let(:success) { described_class.new(status_code: 200) }

    it 'returns true' do
      expect(success.success?).to be true
    end
  end

  describe '#to_h' do
    let(:success) { described_class.new(status_code: 200, message: 'Action succeeded', data: { key: 'value' }) }

    it 'returns a hash representation of the success response' do
      expect(success.to_h).to eq({
        status_code: 200,
        message: 'Action succeeded',
        data: { key: 'value' }
      })
    end
  end

  describe '#to_json' do
    let(:success) { described_class.new(status_code: 200, message: 'Action succeeded', data: { key: 'value' }) }

    it 'returns a JSON representation of the success response' do
      expect(success.to_json).to eq('{"status_code":200,"message":"Action succeeded","data":{"key":"value"}}')
    end
  end
end
