# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  # Handle unexpected errors
  def handle_unexpected_error(exception)
    if exception.is_a?(PhcdevworksAccountsStytch::Stytch::Error)
      handle_custom_error(exception)
    else
      log_error("Unexpected error: #{exception.class.name} - #{exception.message}")
      render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
    end
  end

  # Handle custom errors (e.g., Stytch or ServerError)
  def handle_custom_error(error)
    log_error("Custom error: #{error.message} (Status: #{error.status_code})")
    render json: format_error_response(error), status: error.status_code
  end

  # Handle missing parameters errors
  def handle_missing_params_error(message)
    log_error("Missing parameter error: #{message}")
    render json: { error: message }, status: :unprocessable_entity
  end

  # Log error message
  def log_error(message)
    Rails.logger.error(message)
  end

  private

  # Format the error response for rendering
  def format_error_response(error)
    if error.respond_to?(:to_h)
      error.to_h
    else
      {
        error: error.message,
        status_code: error.respond_to?(:status_code) ? error.status_code : 500,
        error_code: error.respond_to?(:error_code) ? error.error_code : 'unknown_error'
      }
    end
  end
end
