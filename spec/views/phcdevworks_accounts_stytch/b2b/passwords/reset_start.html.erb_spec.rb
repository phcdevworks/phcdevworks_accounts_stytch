require 'rails_helper'

RSpec.describe 'phcdevworks_accounts_stytch/b2b/passwords/reset_start.html.erb', type: :view do
  include PhcdevworksAccountsStytch::Engine.routes.url_helpers

  it 'displays the reset password form' do
    render

    expect(rendered).to have_selector("form[action='#{b2b_process_reset_start_path}'][method='post']")

    expect(rendered).to have_field('email', type: 'email')

    expect(rendered).to have_field('organization_slug', type: 'text')

    expect(rendered).to have_button('Send Reset Instructions')
  end
end
