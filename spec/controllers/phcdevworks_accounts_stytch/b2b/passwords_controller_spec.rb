require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::B2b::PasswordsController, type: :controller do
  let(:service_instance) { PhcdevworksAccountsStytch::Authentication::BaseService.new }
  let(:client_double)    { instance_double("StytchClient") }
  let(:passwords_double) { instance_double("StytchClient::Passwords") }

  let(:organization_slug) { "example-org" }
  let(:valid_email)       { "test@example.com" }
  let(:valid_password)    { "password123" }
  let(:reset_token)       { "reset123" }
  let(:new_password)      { "newpassword123" }

  let(:email)    { valid_email }
  let(:password) { valid_password }

  let(:valid_create_params) do
    {
      organization_slug: organization_slug,
      email: email,
      password: password
    }
  end

  before do
    allow(PhcdevworksAccountsStytch::Authentication::BaseService)
      .to receive(:new).and_return(service_instance)

    allow(service_instance).to receive(:handle_request) do |_args, &block|
      block.call
    end

    allow(service_instance).to receive(:client).and_return(client_double)
    allow(client_double).to receive(:passwords).and_return(passwords_double)
  end

  describe 'POST #create' do
    context 'when the request is successful' do
      it 'calls the Stytch client with the correct arguments and returns :ok' do
        expect(passwords_double).to receive(:create).with(
          organization_slug: organization_slug,
          email: email,
          password: password
        ).and_return({ success: true })

        post :create, params: valid_create_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq("success" => true)
      end
    end

    context 'when the request raises a Stytch error' do
      it 'rescues PhcdevworksAccountsStytch::Stytch::Error and returns the error status' do
        fake_error = PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: 422,
          error_code: 'create_error',
          error_message: 'Something went wrong'
        )
        allow(passwords_double).to receive(:create).and_raise(fake_error)

        post :create, params: valid_create_params
        expect(response).to have_http_status(422)

        parsed_body = JSON.parse(response.body)
        expect(parsed_body['error']).to eq(
          'error_code' => 'create_error',
          'error_message' => 'Something went wrong',
          'status' => 422
        )
      end
    end
  end

  describe "POST #authenticate" do
    context "when successful" do
      it "authenticates the password successfully" do
        allow(service_instance).to receive(:handle_request).and_return({
          status_code: 200,
          message: "Authenticated"
        })

        post :authenticate, params: {
          organization_slug: organization_slug,
          email: valid_email,
          password: valid_password
        }

        expect(service_instance).to have_received(:handle_request).once
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body["message"]).to eq("Authenticated")
      end
    end

    context "when an error occurs" do
      it "returns unauthorized response for invalid credentials" do
        error = PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: 401,
          error_code: "unauthorized",
          error_message: "Invalid credentials"
        )
        allow(service_instance).to receive(:handle_request).and_raise(error)

        post :authenticate, params: {
          organization_slug: organization_slug,
          email: valid_email,
          password: "wrongpassword"
        }

        expect(response.status).to eq(401)
        body = JSON.parse(response.body)
        expect(body["error"]["error_message"]).to eq("Invalid credentials")
      end

      it "returns a 400 error if email is missing" do
        error = PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: 400,
          error_code: "bad_request",
          error_message: "Missing email"
        )
        allow(service_instance).to receive(:handle_request).and_raise(error)

        post :authenticate, params: {
          organization_slug: organization_slug,
          password: valid_password
        }

        expect(response.status).to eq(400)
        body = JSON.parse(response.body)
        expect(body["error"]["error_message"]).to eq("Missing email")
      end

      it "returns a 400 error if password is missing" do
        error = PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: 400,
          error_code: "bad_request",
          error_message: "Missing password"
        )
        allow(service_instance).to receive(:handle_request).and_raise(error)

        post :authenticate, params: {
          organization_slug: organization_slug,
          email: valid_email
        }

        expect(response.status).to eq(400)
        body = JSON.parse(response.body)
        expect(body["error"]["error_message"]).to eq("Missing password")
      end
    end

    context "with the real handle_request (for coverage)" do
      let(:fake_http_response) do
        double("FakeHttpResponse").tap do |resp|
          allow(resp).to receive(:success?).and_return(true)
          allow(resp).to receive(:body).and_return({ success: true }.to_json)
          allow(resp).to receive(:[]).and_return(nil)
          allow(resp).to receive(:[]).with(:http_status_code).and_return(200)
          allow(resp).to receive(:[]).with(:data).and_return({})
        end
      end

      before do
        allow(service_instance).to receive(:handle_request).and_call_original
        allow(passwords_double).to receive(:authenticate).and_return(fake_http_response)
      end

      it "executes the block in #authenticate for coverage" do
        post :authenticate, params: {
          organization_slug: organization_slug,
          email: valid_email,
          password: valid_password
        }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(
          "status_code" => 200,
          "message"     => "Success",
          "data"        => {}
        )
      end
    end
  end

  describe "POST #reset" do
    context "when successful" do
      it "resets the password successfully" do
        allow(service_instance).to receive(:handle_request).and_return({
          status_code: 200,
          message: "Password reset successful"
        })

        post :reset, params: {
          organization_slug: organization_slug,
          email: valid_email,
          reset_token: reset_token,
          new_password: new_password
        }

        expect(service_instance).to have_received(:handle_request).once
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body["message"]).to eq("Password reset successful")
      end
    end

    context "when an error occurs" do
      it "returns not found error for invalid reset token" do
        error = PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: 404,
          error_code: "reset_token_not_found",
          error_message: "Reset token not found"
        )
        allow(service_instance).to receive(:handle_request).and_raise(error)

        post :reset, params: {
          organization_slug: organization_slug,
          email: valid_email,
          reset_token: "invalid",
          new_password: new_password
        }

        expect(response.status).to eq(404)
        body = JSON.parse(response.body)
        expect(body["error"]["error_message"]).to eq("Reset token not found")
      end

      it "returns a 400 error if reset token is missing" do
        error = PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: 400,
          error_code: "bad_request",
          error_message: "Missing reset token"
        )
        allow(service_instance).to receive(:handle_request).and_raise(error)

        post :reset, params: {
          organization_slug: organization_slug,
          email: valid_email,
          new_password: new_password
        }

        expect(response.status).to eq(400)
        body = JSON.parse(response.body)
        expect(body["error"]["error_message"]).to eq("Missing reset token")
      end

      it "returns a 400 error if new password is missing" do
        error = PhcdevworksAccountsStytch::Stytch::Error.new(
          status_code: 400,
          error_code: "bad_request",
          error_message: "Missing new password"
        )
        allow(service_instance).to receive(:handle_request).and_raise(error)

        post :reset, params: {
          organization_slug: organization_slug,
          email: valid_email,
          reset_token: reset_token
        }

        expect(response.status).to eq(400)
        body = JSON.parse(response.body)
        expect(body["error"]["error_message"]).to eq("Missing new password")
      end
    end

    context "with the real handle_request (for coverage)" do
      let(:fake_http_response) do
        double("FakeHttpResponse").tap do |resp|
          allow(resp).to receive(:success?).and_return(true)
          allow(resp).to receive(:body).and_return({ success: true }.to_json)
          allow(resp).to receive(:[]).and_return(nil)
          allow(resp).to receive(:[]).with(:http_status_code).and_return(200)
          allow(resp).to receive(:[]).with(:data).and_return({})
        end
      end

      before do
        allow(service_instance).to receive(:handle_request).and_call_original
        allow(passwords_double).to receive(:reset).and_return(fake_http_response)
      end

      it "executes the block in #reset for coverage" do
        post :reset, params: {
          organization_slug: organization_slug,
          email: valid_email,
          reset_token: reset_token,
          new_password: new_password
        }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(
          "status_code" => 200,
          "message"     => "Success",
          "data"        => {}
        )
      end
    end
  end

  describe "#initialize_service" do
    it "initializes the service correctly" do
      allow(PhcdevworksAccountsStytch::Authentication::BaseService).to receive(:new).and_call_original
      controller_instance = PhcdevworksAccountsStytch::B2b::PasswordsController.new
      controller_instance.send(:initialize_service)
      expect(controller_instance.instance_variable_get(:@service))
        .to be_an_instance_of(PhcdevworksAccountsStytch::Authentication::BaseService)
    end
  end
end
