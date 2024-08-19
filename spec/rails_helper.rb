# frozen_string_literal: true

require 'spec_helper'

# PHCDEVONE - Setting the environment for testing
ENV['RAILS_ENV'] ||= 'test'
require_relative 'dummy/config/environment'

# PHCDEVONE - Abort if accidentally running in production mode
abort('The Rails environment is running in production mode!') if Rails.env.production?

# PHCDEVONE - Loading the Rails test helpers
require 'rspec/rails'
require 'webmock/rspec'
require 'factory_bot_rails'

# PHCDEVONE - Automatically requiring all support files in the spec/support directory
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }
FactoryBot.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
FactoryBot.find_definitions

# PHCDEVONE - Allowing connections to the network with WebMock (used for mocking HTTP requests)
WebMock.allow_net_connect!

# PHCDEVONE - Ensuring that the database schema is up-to-date before running tests
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  # PHCDEVONE - Aborting if there are pending migrations
  abort e.to_s.strip
end

# PHCDEVONE - RSpec configuration
RSpec.configure do |config|
  # PHCDEVONE - Including FactoryBot methods for convenient factory usage in tests
  config.include FactoryBot::Syntax::Methods

  # PHCDEVONE - Setting the path where fixture files are located
  config.fixture_paths = [Rails.root.join('spec/fixtures')]

  # PHCDEVONE - Using transactional fixtures; each test is wrapped in a database transaction
  config.use_transactional_fixtures = true

  # PHCDEVONE - Inferring the spec type (e.g., controller, model) from the file location
  config.infer_spec_type_from_file_location!

  # PHCDEVONE - Filtering out Rails-specific backtrace lines from test failures
  config.filter_rails_from_backtrace!
end
