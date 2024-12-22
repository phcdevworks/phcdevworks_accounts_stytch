# frozen_string_literal: true

namespace :b2b do
  resources :magic_links, only: [] do
    member do
      get :invite, to: 'magic_links#invite'
      get :login, to: 'magic_links#login_or_signup'
      get :signup, to: 'magic_links#login_or_signup'
    end

    collection do
      post :process_invite, to: 'magic_links#process_invite'
      post :process_login_or_signup, to: 'magic_links#process_login_or_signup'
      post :process_revoke_invite, to: 'magic_links#process_revoke_invite'
    end
  end
end
