# frozen_string_literal: true

module HandleServiceAction
  extend ActiveSupport::Concern

  def handle_service_action(action_name, success_status: :ok)
    result = yield
    render json: { message: 'Action completed successfully', data: result }, status: success_status
  rescue PhcdevworksAccountsStytch::Stytch::Error => e
    handle_stytch_error(e, action_name)
  rescue StandardError => e
    handle_unexpected_error(e, action_name)
  end

  private

  def handle_stytch_error(error, action_name)
    Rails.logger.error "Stytch API error during #{action_name}: #{error.message} - Status Code: #{error.status_code}"
    render json: {
      error: error.message,
      code: error.error_code,
      details: error.to_h
    }, status: error.status_code || :bad_request
  end

  def handle_unexpected_error(error, action_name)
    Rails.logger.error "Unexpected error during #{action_name}: #{error.message} - Backtrace: #{error.backtrace.take(5).join("\n")}"
    render json: { error: 'An unexpected error occurred.' }, status: :internal_server_error
  end
end
