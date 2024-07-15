# frozen_string_literal: true

module PhcdevworksAccountsStytch
  class Configuration
    attr_accessor :project_id, :secret, :api_base_url, :google_client_id, :google_client_secret

    def initialize
      @project_id = nil
      @secret = nil
      @api_base_url = 'https://api.stytch.com'
      @google_client_id = nil
      @google_client_secret = nil
    end
  end
end
