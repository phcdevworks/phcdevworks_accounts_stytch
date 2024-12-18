# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  # Handle unexpected errors
  def handle_unexpected_error(exception)
    if exception.is_a?(PhcdevworksAccountsStytch::Stytch::Error)
      handle_custom_error(exception)
    else
      log_error("Unexpected error: #{exception.message}")
      render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
    end
  end

  # Handle custom errors (e.g., Stytch or ServerError)
  def handle_custom_error(error)
    log_error("Custom error: #{error.message} (Status: #{error.status_code})")
    render json: error.to_h, status: error.status_code
  end

  # Handle missing parameters errors
  def handle_missing_params_error(message)
    log_error(message)
    render json: { error: message }, status: :unprocessable_entity
  end

  # Log error message
  def log_error(message)
    Rails.logger.error(message)
  end
end
