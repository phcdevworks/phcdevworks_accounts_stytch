# lib/phcdevworks_accounts_stytch.rb
# frozen_string_literal: true

require 'phcdevworks_accounts_stytch/version'
require 'phcdevworks_accounts_stytch/engine'
require 'phcdevworks_accounts_stytch/configuration'

module PhcdevworksAccountsStytch
  class << self
    attr_accessor :configuration
  end

  self.configuration ||= Configuration.new

  def self.configure
    yield(configuration)
  end
end
