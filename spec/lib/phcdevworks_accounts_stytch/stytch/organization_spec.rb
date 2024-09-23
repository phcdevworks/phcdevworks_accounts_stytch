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
    allow(organizations_client).to receive(:search).and_return({})
  end

  describe '#find_organization_id_by_slug' do
    context 'when an organization is found' do
      before do
        allow(organizations_client).to receive(:search).and_return({ 'organizations' => [{ 'organization_id' => 'org_1234' }] })
      end

      it 'returns the organization ID' do
        result = organization_service.find_organization_id_by_slug(slug)
        expect(result).to eq('org_1234')
      end
    end

    context 'when a generic server error occurs' do
      before do
        allow(organizations_client).to receive(:search).and_raise(
          PhcdevworksAccountsStytch::Stytch::ServerError.new('Unexpected server error')
        )
      end

      it 'raises a server error with a status code of 500' do
        begin
          organization_service.find_organization_id_by_slug(slug)
        rescue PhcdevworksAccountsStytch::Stytch::Error => e
          error = e
        end

        expect(error.status_code).to eq(500)
        expect(error.error_message).to eq('Unexpected server error')
      end
    end

    context 'when no organization is found' do
      before do
        allow(organizations_client).to receive(:search).and_return({ 'organizations' => [] })
      end

      it 'raises a not found error with status code 404' do
        begin
          organization_service.find_organization_id_by_slug(slug)
        rescue PhcdevworksAccountsStytch::Stytch::Error => e
          error = e
        end

        expect(error.status_code).to eq(404)
        expect(error.error_message).to eq('Organization not found')
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

      it 'raises a forbidden access error with status code 403' do
        begin
          organization_service.find_organization_id_by_slug(slug)
        rescue PhcdevworksAccountsStytch::Stytch::Error => e
          error = e
        end

        expect(error.status_code).to eq(403)
        expect(error.error_message).to eq('Forbidden access')
      end
    end

    context 'when an unknown error occurs' do
      before do
        allow(organizations_client).to receive(:search).and_raise(
          PhcdevworksAccountsStytch::Stytch::ServerError.new('Unexpected error', 500)
        )
      end

      it 'raises a server error with status code 500' do
        begin
          organization_service.find_organization_id_by_slug(slug)
        rescue PhcdevworksAccountsStytch::Stytch::Error => e
          error = e
        end

        expect(error.status_code).to eq(500)
        expect(error.error_message).to eq('Unexpected error')
      end
    end
  end

  describe '#search_organization_by_slug' do
    let(:slug) { 'phcdevworks' }

    before do
      allow(organizations_client).to receive(:search).and_return({ 'organizations' => [] })
    end

    it 'sends the correct search query to the client' do
      organization_service.send(:search_organization_by_slug, slug)

      expect(organizations_client).to have_received(:search).with(
        query: {
          operator: 'OR',
          operands: [
            { filter_name: 'organization_slugs', filter_value: [slug] }
          ]
        }
      )
    end

    context 'when a generic error without status_code is raised' do
      before do
        allow(organizations_client).to receive(:search).and_raise(
          StandardError.new('Unexpected server error')
        )
      end

      it 'raises a server error with a status code of 500' do
        begin
          organization_service.find_organization_id_by_slug(slug)
        rescue PhcdevworksAccountsStytch::Stytch::Error => e
          error = e
        end

        expect(error.status_code).to eq(500)
        expect(error.error_message).to eq('Unexpected server error')
      end
    end
  end
end
