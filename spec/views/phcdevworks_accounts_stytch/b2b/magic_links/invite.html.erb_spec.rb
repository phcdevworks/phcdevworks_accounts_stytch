# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'phcdevworks_accounts_stytch/b2b/magic_links/invite.html.erb', type: :view do
  before do
    assign(:organization_slug, 'example-slug')
  end

  it 'displays the invite user via magic link form' do
    render

    expect(rendered).to have_selector('h1', text: 'Invite User via Magic Link')

    expect(rendered).to have_selector("form[action='#{
      phcdevworks_accounts_stytch.b2b_magic_links_process_invite_path(organization_slug: 'example-slug')
    }'][method='post']")

    expect(rendered).to have_selector('label[for="email"]', text: "Invitee's Email")
    expect(rendered).to have_selector('input[name="email"][type="email"][required]')

    expect(rendered).to have_selector('input[type="submit"][value="Send Invite"]')
  end
end
