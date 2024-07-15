# frozen_string_literal: true

require_relative 'lib/phcdevworks_accounts_stytch/version'

Gem::Specification.new do |spec|
  spec.name        = 'phcdevworks_accounts_stytch'
  spec.version     = PhcdevworksAccountsStytch::VERSION
  spec.authors     = ['PHCDevworks', 'Brad Potts']
  spec.email       = ['info@phcdevworks.com', 'brad.potts@phcdevworks.com']
  spec.homepage    = 'https://phcdevworks.com/'
  spec.summary     = 'Rails Engine for Stytch Authentication'
  spec.description = 'PHCDevworks Accounts Stytch is a Ruby on Rails Engine for Stytch Authentication.'
  spec.license     = 'MIT'

  # Specify the required Ruby version
  spec.required_ruby_version = '>= 2.7.0'

  # Gem Meta Data
  spec.metadata['allowed_push_host'] = 'https://rubygems.org/'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/phcdevworks/phcdevworks_accounts_stytch/'
  spec.metadata['changelog_uri'] = 'https://github.com/phcdevworks/phcdevworks_accounts_stytch/releases/'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_runtime_dependency 'rails', '~> 7.1', '>= 7.1.3.4'
  spec.add_dependency 'stytch', '~> 9.1'
end
