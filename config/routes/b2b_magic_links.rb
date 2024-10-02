# frozen_string_literal: true

namespace :b2b do
  # B2B Routes for Magic Links
  get 'magic_links/invite/:organization_slug',
      to: 'magic_links#invite', as: 'magic_links_invite'
  get 'magic_links/login/:organization_slug',
      to: 'magic_links#login_or_signup', as: 'magic_links_login'
  get 'magic_links/signup/:organization_slug',
      to: 'magic_links#login_or_signup', as: 'magic_links_signup'

  post 'magic_links/process_invite/:organization_slug',
       to: 'magic_links#process_invite', as: 'magic_links_process_invite'
  post 'magic_links/process_login_or_signup/:organization_slug',
       to: 'magic_links#process_login_or_signup', as: 'magic_links_process_login_or_signup'
end
