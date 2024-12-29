Rails.application.routes.draw do
  namespace :phcdevworks_accounts_stytch do
    namespace :b2b do
      post "authenticate", to: "authenticate#create"
      delete "logout", to: "authenticate#destroy"
    end
  end
end
