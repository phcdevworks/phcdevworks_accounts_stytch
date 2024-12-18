# frozen_string_literal: true

module HandleServiceAction
  extend ActiveSupport::Concern

  # Handle service action in the controllers
  def handle_service_action(action_name, success_status: :ok)
    result = yield

    if result.is_a?(Hash) && result.key?(:message)
      render json: { message: result[:message], data: result[:data] }, status: success_status
    else
      render json: { message: 'Action completed successfully', data: result }, status: success_status
    end
  rescue PhcdevworksAccountsStytch::Stytch::Error => e
    handle_stytch_error(e, action_name)
  rescue StandardError => e
    handle_unexpected_error(e, action_name)
  end

  private

  # Handle Stytch-specific errors
  def handle_stytch_error(error, action_name)
    log_error("Stytch API error during #{action_name}: #{error.message} (Status Code: #{error.status_code})")
    render json: { error: error.message, code: error.error_code, details: error.to_h }, status: :bad_request
  end

  # Handle unexpected errors
  def handle_unexpected_error(error, action_name)
    log_error("Unexpected error during #{action_name}: #{error.message}")
    render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
  end

  # Log error message
  def log_error(message)
    Rails.logger.error(message)
  end
end
