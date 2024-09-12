require 'rails_helper'

RSpec.describe 'phcdevworks_accounts_stytch/b2b/passwords/reset_with_session.html.erb', type: :view do
  include PhcdevworksAccountsStytch::Engine.routes.url_helpers

  it 'displays the reset password form using a session token' do
    render

    expect(rendered).to have_selector("form[action='#{b2b_process_reset_with_session_path}'][method='post']")

    expect(rendered).to have_field('session_token', type: 'hidden')

    expect(rendered).to have_field('password', type: 'password')

    expect(rendered).to have_button('Reset Password')
  end
end
