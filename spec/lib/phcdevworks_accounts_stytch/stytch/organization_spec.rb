require 'rails_helper'

# Mocking Stytch::Error if not already defined
unless defined?(Stytch::Error)
  module Stytch
    class Error < StandardError
      attr_reader :status_code

      def initialize(message:, status_code:)
        super(message)
        @status_code = status_code
      end
    end
  end
end

RSpec.describe PhcdevworksAccountsStytch::Stytch::Organization do
  let(:client_double) { instance_double('PhcdevworksAccountsStytch::Stytch::Client') }
  let(:b2b_client_double) { instance_double('Stytch::Client::B2B') }
  let(:organization_instance) { described_class.new }
  let(:slug) { 'test-slug' }

  before do
    allow(PhcdevworksAccountsStytch::Stytch::Client).to receive(:b2b_client).and_return(b2b_client_double)
  end

  describe '#find_organization_id_by_slug' do
    context 'when the organization does not exist' do
      let(:response) { { 'organizations' => [] } }

      before do
        allow(b2b_client_double).to receive_message_chain(:organizations, :search).and_return(response)
      end

      it 'raises a not found error' do
        expect do
          organization_instance.find_organization_id_by_slug(slug)
        end.to raise_error(
          PhcdevworksAccountsStytch::Stytch::Error, /Organization with slug 'test-slug' not found/
        )
      end
    end

    context 'when a Stytch::Error is raised' do
      before do
        allow(b2b_client_double).to receive_message_chain(:organizations, :search).and_raise(
          Stytch::Error.new(message: 'Stytch error', status_code: 500)
        )
      end

      it 'raises a wrapped PhcdevworksAccountsStytch::Stytch::Error' do
        expect do
          organization_instance.find_organization_id_by_slug(slug)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error, /Stytch error/)
      end
    end
  end
end
