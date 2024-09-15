# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'phcdevworks_accounts_stytch/b2b/passwords/reset_start.html.erb', type: :view do
  before do
    allow(view).to receive(:params).and_return({ organization_slug: 'example-slug' })
  end

  it 'displays the reset password form' do
    render

    expect(rendered).to have_selector("form[action='#{
      phcdevworks_accounts_stytch.b2b_process_reset_start_path(organization_slug: 'example-slug')}'][method='post']")

    expect(rendered).to have_selector('input[name="email"][type="email"][required]')

    expect(rendered).to have_selector('input[type="submit"][value="Send Reset Instructions"]')
  end
end