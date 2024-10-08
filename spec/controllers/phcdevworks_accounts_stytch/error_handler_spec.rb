# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ErrorHandler, type: :controller do
  controller(ApplicationController) do
    # rubocop:disable RSpec/DescribedClass
    include ErrorHandler
    # rubocop:enable RSpec/DescribedClass

    def test_unexpected_error
      raise StandardError, 'Something went wrong'
    rescue StandardError => e
      handle_unexpected_error(e)
    end

    def test_missing_params_error
      handle_missing_params_error('Email and password are required')
    end

    def log_error(message)
      Rails.logger.error(message)
    end
  end

  before do
    routes.draw do
      get 'test_unexpected_error' => 'anonymous#test_unexpected_error'
      get 'test_missing_params_error' => 'anonymous#test_missing_params_error'
    end
  end

  describe '#handle_unexpected_error' do
    it 'logs the error and returns a 500 status with a generic error message' do
      allow(Rails.logger).to receive(:error)

      get :test_unexpected_error

      expect(Rails.logger).to have_received(:error).with('Unexpected error: Something went wrong')
      expect(response).to have_http_status(:internal_server_error)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'An unexpected error occurred.' })
    end
  end

  describe '#handle_missing_params_error' do
    it 'logs the error and returns a 422 status with a specific error message' do
      allow(Rails.logger).to receive(:error)

      get :test_missing_params_error

      expect(Rails.logger).to have_received(:error).with('Email and password are required')
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Email and password are required' })
    end
  end
end
