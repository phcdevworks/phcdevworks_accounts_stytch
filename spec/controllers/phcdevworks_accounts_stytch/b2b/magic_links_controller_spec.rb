require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::MagicLinksController, type: :controller do
  let(:mock_service) { instance_double(PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService) }
  let(:mock_response) { PhcdevworksAccountsStytch::Stytch::Success.new(status_code: 200, message: 'Success', data: { authenticated: true }) }
  let(:mock_organization_id) { 'org-id' }

  before do
    allow(PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService).to receive(:new).and_return(mock_service)
    allow(controller).to receive(:find_organization_id).with('example-org').and_return(mock_organization_id)
  end

  describe 'POST #send_magic_link' do
    it 'sends a magic link successfully' do
      allow(mock_service).to receive(:send_magic_link).and_return(mock_response)

      post :send_magic_link, params: { organization_slug: 'example-org', email: 'test@example.com' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Success')
    end

    it 'returns an error when organization_slug is invalid' do
      allow(controller).to receive(:find_organization_id).with('invalid-org').and_return(nil)

      post :send_magic_link, params: { organization_slug: 'invalid-org', email: 'test@example.com' }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Organization not found')
    end
  end

  describe 'POST #authenticate_magic_link' do
    it 'authenticates a magic link token successfully' do
      allow(mock_service).to receive(:authenticate_magic_link).and_return(mock_response)

      post :authenticate_magic_link, params: { organization_slug: 'example-org', token: 'magic-token' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Success')
    end
  end
end
