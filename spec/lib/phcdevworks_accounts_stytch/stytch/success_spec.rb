# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::Success do
  subject(:success_instance) { described_class.new(status_code: status_code, message: message, data: data) }

  let(:status_code) { 200 }
  let(:message) { 'Operation was successful.' }
  let(:data) { { key: 'value' } }

  describe '#initialize' do
    it 'sets the status_code' do
      expect(success_instance.status_code).to eq(status_code)
    end

    it 'sets the message' do
      expect(success_instance.message).to eq(message)
    end

    it 'sets the data' do
      expect(success_instance.data).to eq(data)
    end

    it 'defaults message to "Action completed successfully." if not provided' do
      success = described_class.new(status_code: status_code)
      expect(success.message).to eq('Action completed successfully.')
    end

    it 'defaults data to an empty hash if not provided' do
      success = described_class.new(status_code: status_code)
      expect(success.data).to eq({})
    end
  end

  describe '#success?' do
    it 'returns true' do
      expect(success_instance.success?).to be true
    end
  end
end
