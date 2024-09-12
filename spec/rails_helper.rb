# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative 'dummy/config/environment'
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

# Uncomment and customize the line below if you want to auto-require support files.
# Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [Rails.root.join('spec/fixtures')]
  config.use_transactional_fixtures = true
  config.render_views

  # Uncomment this line to disable ActiveRecord support.
  # config.use_active_record = false

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Uncomment to filter additional gems from backtraces.
  # config.filter_gems_from_backtrace("gem name")
end
