# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'phcdevworks_accounts_stytch/b2c/magic_links/login_or_signup.html.erb', type: :view do
  it 'displays the login or sign-up form with magic link' do
    render

    expect(rendered).to have_selector('h1', text: 'Login or Sign Up with Magic Link')

    expect(rendered).to have_selector("form[action='#{
      phcdevworks_accounts_stytch.b2c_magic_links_process_login_or_signup_path
    }'][method='post']")

    expect(rendered).to have_selector('label[for="email"]', text: 'Your Email')
    expect(rendered).to have_selector('input[name="email"][type="email"][required]')

    expect(rendered).to have_selector('input[type="submit"][value="Send Magic Link"]')
  end
end
