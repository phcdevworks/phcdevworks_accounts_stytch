# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'phcdevworks_accounts_stytch/b2c/magic_links/invite.html.erb', type: :view do
  it 'displays the invite user via magic link form' do
    render

    expect(rendered).to have_selector('h1', text: 'Invite User via Magic Link')

    expect(rendered).to have_selector("form[action='#{
      phcdevworks_accounts_stytch.b2c_magic_links_process_invite_path
    }'][method='post']")

    expect(rendered).to have_selector('label[for="email"]', text: "Invitee's Email")
    expect(rendered).to have_selector('input[name="email"][type="email"][required]')

    expect(rendered).to have_selector('input[type="submit"][value="Send Invite"]')
  end
end
