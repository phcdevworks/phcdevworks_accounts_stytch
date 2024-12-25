Rails.application.routes.draw do
mount PhcdevworksAccountsStytch::Engine => '/'
  get "up" => "rails/health#show", as: :rails_health_check
end
