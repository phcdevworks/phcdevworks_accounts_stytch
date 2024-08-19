# frozen_string_literal: true

FactoryBot.define do
  factory :stytch_b2b_client, class: 'StytchB2B::Client' do
    # PHCDEVONE - Provide the required keyword arguments :project_id and :secret
    project_id { Rails.application.credentials.dig(:stytch, :b2b, :project_id) }
    secret { Rails.application.credentials.dig(:stytch, :b2b, :secret) }

    # PHCDEVONE - Initialize the StytchB2B::Client with the provided keyword arguments
    initialize_with { new(project_id: project_id, secret: secret) }
  end
end
