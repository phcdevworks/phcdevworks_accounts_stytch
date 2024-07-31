# frozen_string_literal: true

module PhcdevworksAccountsStytch
  class ApplicationController < ActionController::Base
    helper_method :current_user

    def current_user
      @current_user ||= fetch_user_from_stytch
    end

    private

    def fetch_user_from_stytch
      return unless session[:user_id]

      response = Stytch::Users.get(session[:user_id])
      response.user if response.status == 'success'
    end
  end
end
