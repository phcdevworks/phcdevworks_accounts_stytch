# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::MethodOptions do
  describe '#initialize' do
    it 'assigns the options hash' do
      options = { authorization: { session_token: 'some_token' } }
      method_options = described_class.new(options)

      expect(method_options.options).to eq(options)
    end

    it 'defaults options to an empty hash if no options are provided' do
      method_options = described_class.new

      expect(method_options.options).to eq({})
    end
  end

  describe '#to_headers' do
    context 'when authorization and session_token are provided' do
      it 'returns a hash with the Authorization header' do
        options = { authorization: { session_token: 'some_token' } }
        method_options = described_class.new(options)

        expect(method_options.to_headers).to eq({ 'Authorization' => 'Bearer some_token' })
      end
    end

    context 'when authorization is provided without session_token' do
      it 'returns an empty hash' do
        options = { authorization: { session_token: nil } }
        method_options = described_class.new(options)

        expect(method_options.to_headers).to eq({})
      end
    end

    context 'when authorization is not provided' do
      it 'returns an empty hash' do
        options = {}
        method_options = described_class.new(options)

        expect(method_options.to_headers).to eq({})
      end
    end

    context 'when options are completely empty' do
      it 'returns an empty hash' do
        method_options = described_class.new

        expect(method_options.to_headers).to eq({})
      end
    end
  end
end
