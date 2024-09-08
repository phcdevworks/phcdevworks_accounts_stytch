# frozen_string_literal: true

namespace :b2b do
  get 'magic_links/invite/:organization_slug', to: 'magic_links#invite', as: 'magic_links_invite'
  get 'magic_links/authenticate', to: 'magic_links#authenticate', as: 'magic_links_authenticate'
  get 'magic_links/login/:organization_slug', to: 'magic_links#login_or_signup', as: 'magic_links_login'
  get 'magic_links/signup/:organization_slug', to: 'magic_links#login_or_signup', as: 'magic_links_signup'

  match 'magic_links/process_authenticate', to: 'magic_links#process_authenticate', via: %i[get post],
                                            as: 'magic_links_process_authenticate'

  post 'magic_links/process_invite/:organization_slug', to: 'magic_links#process_invite', as: 'magic_links_process_invite'
  post 'magic_links/process_login_or_signup/:organization_slug', to: 'magic_links#process_login_or_signup',
                                                                 as: 'magic_links_process_login_or_signup'

  post 'passwords/authenticate', to: 'passwords#authenticate',
                                 as: 'passwords_authenticate'
  post 'passwords/process_authenticate',
       to: 'passwords#process_authenticate', as: 'passwords_process_authenticate'
end
