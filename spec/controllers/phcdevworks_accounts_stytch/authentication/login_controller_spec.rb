# frozen_string_literal: true

require 'rails_helper'
require 'stytch' # Ensure the Stytch library is loaded

module PhcdevworksAccountsStytch
  module Authentication
    RSpec.describe LoginController, type: :controller do
      routes { PhcdevworksAccountsStytch::Engine.routes }

      describe 'POST #create' do
        let(:email) { 'test@example.com' }
        let(:response_body) { { 'message' => 'Magic link sent' } }
        let(:client) { instance_double(StytchB2B::Client) }
        let(:magic_links) { instance_double(MagicLinks) }
        let(:email_instance) { instance_double(Email) }

        before do
          allow(controller).to receive(:stytch_client).and_return(client)
          allow(client).to receive(:magic_links).and_return(magic_links)
          allow(magic_links).to receive(:email).and_return(email_instance)
          allow(email_instance).to receive_messages(discovery: email_instance, send: response_body)
        end

        it 'returns a successful status' do
          post :create, params: { email: email }
          expect(response).to have_http_status(:success)
        end

        it 'returns the correct response body' do
          post :create, params: { email: email }
          expect(response.body).to eq(response_body.to_json)
        end
      end
    end
  end
end
