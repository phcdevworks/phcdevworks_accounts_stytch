# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative 'dummy/config/environment'
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

# Enable logging to stdout for debugging
RSpec.configure do |config|
  # Set up a logger for RSpec
  config.before(:suite) do
    Rails.logger = Logger.new(STDOUT)
    Rails.logger.level = Logger::DEBUG
    Rails.logger.info "RSpec suite started at #{Time.now}"
  end

  config.after(:suite) do
    Rails.logger.info "RSpec suite finished at #{Time.now}"
  end

  # Log the start and end of each example
  config.around do |example|
    Rails.logger.info "Starting example: #{example.full_description}"
    example.run
    Rails.logger.info "Finished example: #{example.full_description} (#{example.execution_result.status})"
  end

  # Set paths for fixtures
  config.fixture_paths = [Rails.root.join('spec/fixtures')]
  config.use_transactional_fixtures = true
  config.render_views

  # Infer spec types from file location
  config.infer_spec_type_from_file_location!

  # Filter Rails backtrace in logs
  config.filter_rails_from_backtrace!

  # Uncomment and customize to filter additional gems from backtraces.
  # config.filter_gems_from_backtrace("gem name")

  # Maintain the test schema before suite execution
  begin
    ActiveRecord::Migration.maintain_test_schema!
  rescue ActiveRecord::PendingMigrationError => e
    abort e.to_s.strip
  end

  # Enable automatic support file loading if needed
  # Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }
end
