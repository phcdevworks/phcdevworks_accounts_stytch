Rails.application.routes.draw do
  namespace :phcdevworks_accounts_stytch do
    namespace :b2b do
      post "authenticate", to: "authenticate#create"
      delete "logout", to: "authenticate#destroy"
      scope ":organization_slug" do
        post "magic_links/send", to: "magic_links#send_magic_link"
        post "magic_links/authenticate", to: "magic_links#authenticate_magic_link"
        get "magic_links/login", to: "magic_links#login", as: :magic_link_login
        get "magic_links/signup", to: "magic_links#signup", as: :magic_link_signup

        post "passwords/create", to: "passwords#create", as: :password_create
        post "passwords/authenticate", to: "passwords#authenticate", as: :password_authenticate
        post "passwords/reset", to: "passwords#reset", as: :password_reset
      end
    end
  end
end
