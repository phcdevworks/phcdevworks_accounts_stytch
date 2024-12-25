module PhcdevworksAccountsStytch
  class Engine < ::Rails::Engine
    # Load the engine's namespace
    isolate_namespace PhcdevworksAccountsStytch

    config.autoload_paths << File.expand_path("../../lib", __dir__)
  end
end
