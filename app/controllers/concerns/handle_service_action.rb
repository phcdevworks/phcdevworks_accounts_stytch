# frozen_string_literal: true

module HandleServiceAction
  extend ActiveSupport::Concern

  # Handle service action in the controllers
  def handle_service_action(action_name)
    result = yield
    if result.is_a?(Hash) && result.key?(:message)
      render json: { message: result[:message], data: result[:data] }, status: :ok
    else
      render json: { message: 'Action completed successfully', data: result }, status: :ok
    end
  rescue PhcdevworksAccountsStytch::Stytch::Error => e
    log_error("Stytch API error during #{action_name}: #{e.message}")
    render json: { error: e.message }, status: :bad_request
  end
end
