# frozen_string_literal: true

require 'rails_helper'
require 'stytch' # Ensure the Stytch library is loaded

# Define FakeResponse outside of the RSpec block
class FakeResponse
  attr_reader :email_address, :intermediate_session_token

  def initialize(email_address:, intermediate_session_token:)
    @email_address = email_address
    @intermediate_session_token = intermediate_session_token
  end
end

module PhcdevworksAccountsStytch
  module Authentication
    RSpec.describe ProcessorController, type: :controller do
      routes { PhcdevworksAccountsStytch::Engine.routes }

      describe 'POST #create' do
        let(:token) { 'some-token' }
        let(:response_body) do
          instance_double(
            FakeResponse,
            email_address: 'test@example.com',
            intermediate_session_token: 'intermediate-token'
          )
        end
        let(:client) { instance_double(StytchB2B::Client) }
        let(:magic_links) { instance_double(StytchB2B::MagicLinks) }
        let(:discovery) { instance_double(StytchB2B::MagicLinks::Discovery) }

        before do
          allow(controller).to receive(:stytch_client).and_return(client)
          allow(client).to receive(:magic_links).and_return(magic_links)
          allow(magic_links).to receive(:discovery).and_return(discovery)
          allow(discovery).to receive(:authenticate).and_return(response_body)
        end

        it 'returns a successful status' do
          post :create, params: { token: token }
          expect(response).to have_http_status(:success)
        end

        it 'returns the correct success message' do
          post :create, params: { token: token }
          expected_message = 'Hello, test@example.com! Complete the Discovery flow by creating an ' \
                             'Organization with your intermediate session token: intermediate-token.'
          expect(response.body).to eq(expected_message)
        end

        context 'when an error occurs' do
          before do
            allow(discovery).to receive(:authenticate).and_raise(StandardError, 'Something went wrong')
          end

          it 'returns an unauthorized status' do
            post :create, params: { token: token }
            expect(response).to have_http_status(:unauthorized)
          end

          it 'returns the error message' do
            post :create, params: { token: token }
            expect(response.body).to eq('Something went wrong')
          end
        end
      end
    end
  end
end
