require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::MagicLinksController, type: :controller do
  let(:mock_service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService) }
  let(:mock_response) { PhcdevworksAccountsStytch::Stytch::Success.new(status_code: 200, message: 'Success', data: { authenticated: true }) }
  let(:mock_error) do
    PhcdevworksAccountsStytch::Stytch::Error.new(
      status_code: 400,
      error_code: 'mock_error',
      error_message: 'A mock error occurred'
    )
  end
  let(:mock_organization_id) { 'org-id' }

  before do
    allow(PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService).to receive(:new).and_return(mock_service)

    # Mock the Organization class with a find_by method
    stub_const('Organization', Class.new do
      def self.find_by(slug:)
        nil
      end
    end)
  end

  describe 'POST #send_magic_link' do
    context 'when the organization_slug is valid' do
      before do
        allow(controller).to receive(:find_organization_id).with('example-org').and_return(mock_organization_id)
      end

      it 'sends a magic link successfully' do
        allow(mock_service).to receive(:send_magic_link).and_return(mock_response)

        post :send_magic_link, params: { organization_slug: 'example-org', email: 'test@example.com' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Success')
      end

      it 'handles errors from the service' do
        allow(mock_service).to receive(:send_magic_link).and_raise(mock_error)

        post :send_magic_link, params: { organization_slug: 'example-org', email: 'test@example.com' }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']['error_code']).to eq('mock_error')
      end
    end

    context 'when the organization_slug is invalid' do
      before do
        allow(controller).to receive(:find_organization_id).with('invalid-org').and_return(nil)
      end

      it 'returns a not found error' do
        post :send_magic_link, params: { organization_slug: 'invalid-org', email: 'test@example.com' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Organization not found')
      end
    end
  end

  describe 'POST #authenticate_magic_link' do
    context 'when the organization_slug is valid' do
      before do
        allow(controller).to receive(:find_organization_id).with('example-org').and_return(mock_organization_id)
      end

      it 'authenticates a magic link token successfully' do
        allow(mock_service).to receive(:authenticate_magic_link).and_return(mock_response)

        post :authenticate_magic_link, params: { organization_slug: 'example-org', token: 'magic-token' }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Success')
      end

      it 'handles errors from the service' do
        allow(mock_service).to receive(:authenticate_magic_link).and_raise(mock_error)

        post :authenticate_magic_link, params: { organization_slug: 'example-org', token: 'magic-token' }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']['error_code']).to eq('mock_error')
      end
    end

    context 'when the organization_slug is invalid' do
      before do
        allow(controller).to receive(:find_organization_id).with('invalid-org').and_return(nil)
      end

      it 'returns a not found error' do
        post :authenticate_magic_link, params: { organization_slug: 'invalid-org', token: 'magic-token' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Organization not found')
      end
    end
  end

  describe '#find_organization_id' do
    it 'returns organization_id for a valid slug' do
      organization = double('Organization', organization_id: 'org-id')
      allow(Organization).to receive(:find_by).with(slug: 'valid-slug').and_return(organization)

      expect(controller.send(:find_organization_id, 'valid-slug')).to eq('org-id')
    end

    it 'returns nil for an invalid slug' do
      allow(Organization).to receive(:find_by).with(slug: 'invalid-slug').and_return(nil)

      expect(controller.send(:find_organization_id, 'invalid-slug')).to be_nil
    end
  end
end
