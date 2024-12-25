require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::Client do
  describe '.instance' do
    context 'when type is :b2b' do
      it 'returns a B2B client' do
        client = described_class.instance(:b2b)
        expect(client).to be_a(StytchB2B::Client)
      end
    end

    context 'when type is :b2c' do
      it 'returns a B2C client' do
        client = described_class.instance(:b2c)
        expect(client).to be_a(::Stytch::Client)
      end
    end

    context 'when type is invalid' do
      it 'raises an ArgumentError' do
        expect { described_class.instance(:invalid) }.to raise_error(ArgumentError, 'Invalid client type')
      end
    end
  end
end
