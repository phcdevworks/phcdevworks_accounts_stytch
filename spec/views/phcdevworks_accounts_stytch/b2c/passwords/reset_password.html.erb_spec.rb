# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'phcdevworks_accounts_stytch/b2c/passwords/reset_password.html.erb', type: :view do
  it 'displays the reset password form' do
    render

    expect(rendered).to have_selector("form[action='#{
      phcdevworks_accounts_stytch.b2c_process_password_reset_path
    }'][method='post']")

    expect(rendered).to have_selector('input[name="token"][type="text"][required]')

    expect(rendered).to have_selector('input[name="password"][type="password"][required]')

    expect(rendered).to have_selector('input[type="submit"][value="Reset Password"]')
  end
end
