# frozen_string_literal: true

module PhcdevworksAccountsStytch
  class Engine < ::Rails::Engine
    isolate_namespace PhcdevworksAccountsStytch

    initializer 'phcdevworks_accounts_stytch.configure_stytch' do
      PhcdevworksAccountsStytch::StytchClient.client
    end
  end
end
