require 'rails_helper'

RSpec.describe PhcdevworksAccountsStytch::Stytch::Response do
  # Mock logger to prevent actual logging
  class MockLogger
    attr_reader :error_messages
    
    def initialize
      @error_messages = []
    end

    def error(message)
      @error_messages << message
    end
  end

  describe '.handle_response' do
    context 'with successful responses' do
      [
        [200, 'Success'],
        [201, 'Created'],
        [204, 'Success'],
        [250, 'Success']
      ].each do |status_code, expected_message|
        context "with status code #{status_code}" do
          let(:response) do 
            {
              http_status_code: status_code,
              status: expected_message,
              data: { user_id: 'test_user' }
            }
          end

          it 'returns a Success object' do
            result = described_class.handle_response(response)
            
            expect(result).to be_a(PhcdevworksAccountsStytch::Stytch::Success)
            expect(result.status_code).to eq(status_code)
            expect(result.message).to eq(expected_message)
            expect(result.data).to eq(response)
          end
        end
      end
    end

    context 'with error responses' do
      [
        [400, 'Bad Request'],
        [401, 'Unauthorized'],
        [403, 'Forbidden'],
        [404, 'Not Found'],
        [500, 'Internal Server Error'],
        [599, 'Error']
      ].each do |status_code, expected_message|
        context "with status code #{status_code}" do
          let(:error_response) do
            {
              http_status_code: status_code,
              stytch_api_error: {
                error_type: 'test_error',
                error_message: 'Test error message'
              }
            }
          end

          it 'raises a Stytch Error' do
            expect {
              described_class.handle_response(error_response)
            }.to raise_error(
              PhcdevworksAccountsStytch::Stytch::Error,
              /Test error message/
            )
          end

          it 'raises an error with correct details' do
            begin
              described_class.handle_response(error_response)
            rescue PhcdevworksAccountsStytch::Stytch::Error => e
              expect(e.status_code).to eq(status_code)
              expect(e.error_code).to eq('test_error')
              expect(e.error_message).to eq('Test error message')
            end
          end
        end
      end

      context 'with minimal error response' do
        let(:minimal_error_response) do
          {
            http_status_code: 500
          }
        end

        it 'uses default error values' do
          expect {
            described_class.handle_response(minimal_error_response)
          }.to raise_error(
            PhcdevworksAccountsStytch::Stytch::Error,
            /An unknown error occurred/
          )
        end
      end
    end

    describe 'error logging' do
      before do
        # Mock Rails logger
        allow(Rails).to receive(:logger).and_return(MockLogger.new)
      end

      context 'when an error occurs' do
        let(:error_response) do
          {
            http_status_code: 400,
            stytch_api_error: {
              error_type: 'validation_error',
              error_message: 'Validation failed'
            }
          }
        end

        it 'logs the error when Rails is defined' do
          begin
            described_class.handle_response(error_response)
          rescue PhcdevworksAccountsStytch::Stytch::Error
            # Expected error
          end

          # Access the mock logger
          logged_messages = Rails.logger.error_messages
          
          expect(logged_messages).to include(
            a_string_including(
              '[Stytch API Error]', 
              'Status Code: 400', 
              'Error Code: validation_error', 
              'Message: Validation failed'
            )
          )
        end
      end
    end

    describe '.default_status_message' do
      [
        [200, 'Success'],
        [201, 'Created'],
        [400, 'Bad Request'],
        [401, 'Unauthorized'],
        [403, 'Forbidden'],
        [404, 'Not Found'],
        [500, 'Internal Server Error'],
        [600, 'Error']
      ].each do |status_code, expected_message|
        it "returns '#{expected_message}' for status code #{status_code}" do
          expect(described_class.default_status_message(status_code)).to eq(expected_message)
        end
      end
    end

    describe '.success_status?' do
      [
        [200, true],
        [250, true],
        [299, true],
        [300, false],
        [400, false],
        [500, false]
      ].each do |status_code, is_success|
        it "returns #{is_success} for status code #{status_code}" do
          expect(described_class.success_status?(status_code)).to eq(is_success)
        end
      end
    end
  end
end