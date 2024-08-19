# frozen_string_literal: true

FactoryBot.define do
  factory :magic_links_email, class: 'StytchB2B::MagicLinks::Email' do
    initialize_with { new }
  end
end
