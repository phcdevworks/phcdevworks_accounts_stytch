# frozen_string_literal: true

module PhcdevworksAccountsStytch
  class Engine < ::Rails::Engine
    # Load the engine's namespace
    isolate_namespace PhcdevworksAccountsStytch

    # Load Stytch clients
    initializer 'phcdevworks_accounts_stytch.configure_stytch' do
      PhcdevworksAccountsStytch::Stytch::Client.b2b_client
      PhcdevworksAccountsStytch::Stytch::Client.b2c_client
    rescue StandardError => e
      Rails.logger.error "Stytch Client Initialization Error: #{e.message}"
    end

    # Load lib files
    config.autoload_paths += %W[#{config.root}/lib]
  end
end
