# frozen_string_literal: true

module PhcdevworksAccountsStytch
  class Engine < ::Rails::Engine
    isolate_namespace PhcdevworksAccountsStytch

    initializer 'phcdevworks_accounts_stytch.configure_stytch' do
      PhcdevworksAccountsStytch::Stytch::Client.b2b_client
      PhcdevworksAccountsStytch::Stytch::Client.b2c_client
    end
    config.autoload_paths += %W[#{config.root}/lib]
  end
end
