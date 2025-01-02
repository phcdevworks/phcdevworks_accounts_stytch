require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::PasswordsController, type: :controller do
  let(:service) { instance_double("PhcdevworksAccountsStytch::Authentication::BaseService") }
  let(:organization_slug) { "example-org" }

  before do
    allow(PhcdevworksAccountsStytch::Authentication::BaseService).to receive(:new).and_return(service)
  end

  describe "POST #create" do
    it "creates a password successfully" do
      allow(service).to receive(:handle_request).and_return({ status_code: 200, message: "Password created successfully" })

      post :create, params: { organization_slug: organization_slug, email: "test@example.com", password: "password123" }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["message"]).to eq("Password created successfully")
    end
  end

  describe "POST #authenticate" do
    it "authenticates a password successfully" do
      allow(service).to receive(:handle_request).and_return({ status_code: 200, message: "Authenticated" })

      post :authenticate, params: { organization_slug: organization_slug, email: "test@example.com", password: "password123" }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["message"]).to eq("Authenticated")
    end
  end

  describe "POST #reset" do
    it "resets a password successfully" do
      allow(service).to receive(:handle_request).and_return({ status_code: 200, message: "Password reset successful" })

      post :reset, params: { organization_slug: organization_slug, email: "test@example.com", reset_token: "reset123", new_password: "newpassword123" }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["message"]).to eq("Password reset successful")
    end
  end
end
