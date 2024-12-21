require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::MethodOptions do
  let(:authorization_options) { { authorization: { session_token: 'test_token' } } }
  let(:custom_headers_options) { { content_type: 'application/json', accept: 'application/vnd.api+json' } }
  let(:combined_options) { authorization_options.merge(custom_headers_options) }
  let(:empty_options) { {} }

  describe '#initialize' do
    context 'when options are provided' do
      subject { described_class.new(combined_options) }

      it 'sets the options' do
        expect(subject.options).to eq(combined_options)
      end
    end

    context 'when options are not provided' do
      subject { described_class.new }

      it 'sets options to an empty hash' do
        expect(subject.options).to eq({})
      end
    end
  end

  describe '#to_headers' do
    context 'when only authorization options are provided' do
      subject { described_class.new(authorization_options) }

      it 'includes the Authorization header' do
        expect(subject.to_headers).to include('Authorization' => 'Bearer test_token')
      end
    end

    context 'when only custom headers are provided' do
      subject { described_class.new(custom_headers_options) }

      it 'includes the Content-Type header' do
        expect(subject.to_headers).to include('Content-Type' => 'application/json')
      end

      it 'includes the Accept header' do
        expect(subject.to_headers).to include('Accept' => 'application/vnd.api+json')
      end
    end

    context 'when both authorization and custom headers are provided' do
      subject { described_class.new(combined_options) }

      it 'includes the Authorization header' do
        expect(subject.to_headers).to include('Authorization' => 'Bearer test_token')
      end

      it 'includes the Content-Type header' do
        expect(subject.to_headers).to include('Content-Type' => 'application/json')
      end

      it 'includes the Accept header' do
        expect(subject.to_headers).to include('Accept' => 'application/vnd.api+json')
      end
    end

    context 'when no options are provided' do
      subject { described_class.new(empty_options) }

      it 'returns an empty hash' do
        expect(subject.to_headers).to eq({})
      end
    end
  end

  describe '#headers' do
    let(:options) { combined_options }
    subject { described_class.new(options) }

    it 'is an alias for #to_headers' do
      expect(subject.headers).to eq(subject.to_headers)
    end
  end

  describe 'private methods' do
    subject { described_class.new(combined_options) }

    describe '#add_authorization_header' do
      let(:headers) { {} }

      it 'adds the Authorization header when session_token is present' do
        subject.send(:add_authorization_header, headers)
        expect(headers).to include('Authorization' => 'Bearer test_token')
      end

      it 'does not add the Authorization header when session_token is missing' do
        invalid_options = { authorization: {} }
        subject = described_class.new(invalid_options)
        subject.send(:add_authorization_header, headers)
        expect(headers).not_to include('Authorization')
      end
    end

    describe '#add_custom_headers' do
      let(:headers) { {} }

      it 'adds the Content-Type header when present in options' do
        subject.send(:add_custom_headers, headers)
        expect(headers).to include('Content-Type' => 'application/json')
      end

      it 'adds the Accept header when present in options' do
        subject.send(:add_custom_headers, headers)
        expect(headers).to include('Accept' => 'application/vnd.api+json')
      end

      it 'does not add headers that are missing in options' do
        subject = described_class.new(empty_options)
        subject.send(:add_custom_headers, headers)
        expect(headers).to eq({})
      end
    end
  end
end
