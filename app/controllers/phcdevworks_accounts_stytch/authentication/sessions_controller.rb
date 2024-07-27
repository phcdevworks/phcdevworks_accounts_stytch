# frozen_string_literal: true

module PhcdevworksAccountsStytch
  module Authentication
    class SessionsController < ApplicationController
      def google_login
        url = PhcdevworksAccountsStytch::StytchClient.client.oauth.start(
          provider: 'google',
          redirect_url: google_callback_url,
          login_magic_links: true
        )['url']
        redirect_to url
      end

      def google_callback
        token = params[:token]
        response = PhcdevworksAccountsStytch::StytchClient.client.oauth.authenticate(
          token: token,
          session_duration_minutes: 30
        )

        # Handle the response and authenticate the user within your application.
        user_info = response['user']

        # For demonstration purposes, store user information in the session.
        session[:user_info] = user_info

        # Redirect to a dashboard or home page.
        redirect_to main_app.root_path, notice: 'Successfully logged in with Google!'
      end

      private

      def google_callback_url
        main_app.url_for(controller: 'phcdevworks_accounts_stytch/authentication/sessions', action: 'google_callback',
                         host: request.host, protocol: request.protocol)
      end
    end
  end
end
