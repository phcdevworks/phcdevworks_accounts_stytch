# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Stytch
    module AuthHelper
      def require_login
        return if logged_in?

        redirect_to login_path, alert: 'You must be logged in to access this section'
      end

      def logged_in?
        !!session[:user_id]
      end
    end
  end
end
