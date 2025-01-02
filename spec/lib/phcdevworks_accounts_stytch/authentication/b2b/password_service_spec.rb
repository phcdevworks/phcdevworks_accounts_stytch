require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Authentication::B2b::PasswordService do
  let(:client) { instance_double("StytchB2B::Client") }
  let(:service) { described_class.new(client: client) }
  let(:organization_id) { "organization-test-12345" }

  describe "#create_password" do
    it "creates a password successfully" do
      allow(client).to receive_message_chain(:passwords, :create).and_return({ status_code: 200, data: { message: "Password created" } })

      result = service.create_password(organization_id: organization_id, email: "test@example.com", password: "password123")
      expect(result[:data][:message]).to eq("Password created")
    end
  end

  describe "#authenticate_password" do
    it "authenticates a password successfully" do
      allow(client).to receive_message_chain(:passwords, :authenticate).and_return({ status_code: 200, data: { message: "Authenticated" } })

      result = service.authenticate_password(organization_id: organization_id, email: "test@example.com", password: "password123")
      expect(result[:data][:message]).to eq("Authenticated")
    end
  end

  describe "#reset_password" do
    it "resets a password successfully" do
      allow(client).to receive_message_chain(:passwords, :reset).and_return({ status_code: 200, data: { message: "Password reset successful" } })

      result = service.reset_password(
        organization_id: organization_id,
        email: "test@example.com",
        reset_token: "reset123",
        new_password: "newpassword123"
      )
      expect(result[:data][:message]).to eq("Password reset successful")
    end
  end
end
