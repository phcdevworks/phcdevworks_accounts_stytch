# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  def handle_unexpected_error(exception)
    log_error("Unexpected error: #{exception.message}")
    render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
  end

  def handle_missing_params_error(message)
    log_error(message)
    render json: { error: message }, status: :unprocessable_entity
  end

  def log_error(message)
    Rails.logger.error(message)
  end
end
