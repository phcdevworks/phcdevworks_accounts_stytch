# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'phcdevworks_accounts_stytch/b2c/passwords/reset_existing_password.html.erb', type: :view do
  it 'displays the reset password form using the existing password' do
    render

    expect(rendered).to have_selector("form[action='#{
      phcdevworks_accounts_stytch.b2c_process_reset_existing_password_path
    }'][method='post']")

    expect(rendered).to have_selector('input[name="email"][type="email"][required]')

    expect(rendered).to have_selector('input[name="old_password"][type="password"][required]')

    expect(rendered).to have_selector('input[name="new_password"][type="password"][required]')

    expect(rendered).to have_selector('input[type="submit"][value="Reset Password"]')
  end
end
