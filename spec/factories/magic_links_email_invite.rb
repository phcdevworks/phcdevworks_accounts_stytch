# frozen_string_literal: true

FactoryBot.define do
  factory :magic_links_email_invite, class: 'StytchB2B::MagicLinks::Email::Invite' do
    email_address { Faker::Internet.email }
    organization_id { Faker::Alphanumeric.alphanumeric(number: 10) }

    initialize_with { new(email_address: email_address, organization_id: organization_id) }
  end
end
