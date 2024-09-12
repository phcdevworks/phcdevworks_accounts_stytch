require 'rails_helper'

RSpec.describe 'phcdevworks_accounts_stytch/b2b/passwords/reset_with_session.html.erb', type: :view do
  before do
    allow(view).to receive(:params).and_return({ organization_slug: 'example-slug' })
  end

  it 'displays the reset password form using a session token' do
    render

    expect(rendered).to have_selector("form[action='#{phcdevworks_accounts_stytch.b2b_process_reset_session_path(organization_slug: 'example-slug')}'][method='post']")

    expect(rendered).to have_selector('input[name="session_token"][type="text"][required]')

    expect(rendered).to have_selector('input[name="password"][type="password"][required]')

    expect(rendered).to have_selector('input[type="submit"][value="Reset Password"]')
  end
end
