# frozen_string_literal: true

# PHCDEVONE - RSpec configuration block
RSpec.configure do |config|
  # PHCDEVONE - Configuration for expectation syntax
  config.expect_with :rspec do |expectations|
    # PHCDEVONE - This setting enables the inclusion of chain clauses in custom matcher descriptions
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # PHCDEVONE - Configuration for mock syntax
  config.mock_with :rspec do |mocks|
    # PHCDEVONE - Ensures that only valid methods can be stubbed on partial doubles (e.g., instances of ActiveRecord models)
    mocks.verify_partial_doubles = true
  end

  # PHCDEVONE - Setting to apply metadata to the hosting group (e.g., :type => :controller) to shared contexts
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
