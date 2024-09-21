# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::Organization do
  let(:client) { instance_double(StytchB2B::Client) }
  let(:organizations_client) { instance_double(StytchB2B::Organizations) }
  let(:organization_service) { described_class.new }
  let(:slug) { 'phcdevworks' }

  before do
    allow(PhcdevworksAccountsStytch::Stytch::Client).to receive(:b2b_client).and_return(client)
    allow(client).to receive(:organizations).and_return(organizations_client)
  end

  describe '#find_organization_id_by_slug' do
    context 'when the organization is not found' do
      before do
        allow(organizations_client).to receive(:search).and_return({
                                                                     'organizations' => [] # Simulate no organizations found
                                                                   })
      end

      it 'raises a not found error with the new message' do
        expect do
          organization_service.find_organization_id_by_slug(slug)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error) do |e|
          expect(e.status_code).to eq(404)
          expect(e.error_message).to eq('Organization not found')
        end
      end
    end

    context 'when a forbidden access error occurs' do
      before do
        allow(organizations_client).to receive(:search).and_raise(
          PhcdevworksAccountsStytch::Stytch::Error.new(
            status_code: 403,
            error_message: 'Forbidden access'
          )
        )
      end

      it 'raises a forbidden access error with the correct message' do
        expect do
          organization_service.find_organization_id_by_slug(slug)
        end.to raise_error(PhcdevworksAccountsStytch::Stytch::Error) do |e|
          expect(e.status_code).to eq(403)
          expect(e.error_message).to eq('Forbidden access')
        end
      end
    end
  end

  describe '#search_organization_by_slug' do
    let(:slug) { 'phcdevworks' }

    before do
      allow(organizations_client).to receive(:search).and_return({
                                                                   'organizations' => [{ 'organization_id' => 'phcdevworks' }] # Dummy response to prevent error
                                                                 })
    end

    it 'sends the correct search query to the client' do
      expect(organizations_client).to receive(:search).with(
        query: {
          operator: 'OR',
          operands: [
            { filter_name: 'organization_slugs', filter_value: [slug] }
          ]
        }
      ).and_return({})

      organization_service.find_organization_id_by_slug(slug)
    end
  end
end
