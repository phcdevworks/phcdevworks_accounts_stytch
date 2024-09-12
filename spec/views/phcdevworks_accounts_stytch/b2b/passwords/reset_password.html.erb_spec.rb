require 'rails_helper'

RSpec.describe 'phcdevworks_accounts_stytch/b2b/passwords/reset_password.html.erb', type: :view do
  include PhcdevworksAccountsStytch::Engine.routes.url_helpers

  it 'displays the reset password form' do
    render

    expect(rendered).to have_selector("form[action='#{b2b_process_password_reset_path}'][method='post']")

    expect(rendered).to have_field('token', type: 'hidden')

    expect(rendered).to have_field('password', type: 'password')

    expect(rendered).to have_button('Reset Password')
  end
end
