require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Authentication::B2b::MagicLinkService do
  let(:service) { described_class.new }
  let(:mock_response) { { http_status_code: 200, data: { success: true } } }
  let(:mock_email_service) { double('MagicLinks::Email') }

  before do
    allow(service.client.magic_links).to receive(:email).and_return(mock_email_service)
  end

  describe '#send_magic_link' do
    it 'sends a magic link with organization_slug' do
      allow(mock_email_service).to receive(:login_or_create).and_return(mock_response)

      result = service.send_magic_link(
        email: 'test@example.com',
        organization_id: 'org-id',
        organization_slug: 'example-org'
      )

      expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
      expect(result.data[:success]).to be true
    end
  end

  describe '#authenticate_magic_link' do
    it 'authenticates a magic link token' do
      allow(service.client.magic_links).to receive(:authenticate).and_return(mock_response)

      result = service.authenticate_magic_link(token: 'magic-token')

      expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
      expect(result.data[:success]).to be true
    end
  end
end
