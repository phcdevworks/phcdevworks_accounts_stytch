# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HandleServiceAction, type: :controller do
  controller(ApplicationController) do
    include HandleServiceAction

    def log_error(message)
      Rails.logger.error(message)
    end

    def test_action_with_message
      handle_service_action('Test Action') do
        { message: 'Test message', data: { key: 'value' } }
      end
    end

    def test_action_without_message
      handle_service_action('Test Action') do
        { key: 'value' }
      end
    end

    def test_action_with_error
      handle_service_action('Test Action') do
        raise PhcdevworksAccountsStytch::Stytch::Error.new(status_code: 400, error_message: 'Something went wrong')
      end
    end
  end

  let(:error_message) { 'Stytch Error (Status Code: 400) - Message: Something went wrong' }

  before do
    routes.draw do
      post 'test_action_with_message' => 'anonymous#test_action_with_message'
      post 'test_action_without_message' => 'anonymous#test_action_without_message'
      post 'test_action_with_error' => 'anonymous#test_action_with_error'
    end
  end

  describe 'handle_service_action' do
    context 'when the result contains a message' do
      it 'renders a JSON response with message and data' do
        post :test_action_with_message

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Test message', 'data' => { 'key' => 'value' } })
      end
    end

    context 'when the result does not contain a message' do
      it 'renders a default success message' do
        post :test_action_without_message

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Action completed successfully', 'data' => { 'key' => 'value' } })
      end
    end

    context 'when a PhcdevworksAccountsStytch::Stytch::Error is raised' do
      it 'renders a JSON error response with bad_request status' do
        post :test_action_with_error

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => error_message })
      end
    end
  end
end
