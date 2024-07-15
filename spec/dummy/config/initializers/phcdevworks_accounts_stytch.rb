# frozen_string_literal: true

StytchClientConfig = Struct.new(:project_id, :secret).new(
  ENV['STYTCH_PROJECT_ID'],
  ENV['STYTCH_SECRET']
)
