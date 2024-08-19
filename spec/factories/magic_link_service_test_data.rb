# frozen_string_literal: true

require 'ostruct'
FactoryBot.define do
  factory :magic_link_service_test_data, class: OpenStruct do
    email { Faker::Internet.email }
    organization_id { Faker::Alphanumeric.alphanumeric(number: 10) }
    session_token { Faker::Alphanumeric.alphanumeric(number: 20) }
    token { Faker::Alphanumeric.alphanumeric(number: 20) }

    initialize_with { new(attributes) }
  end
end
