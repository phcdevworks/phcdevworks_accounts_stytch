# frozen_string_literal: true

PhcdevworksAccountsStytch::Engine.routes.draw do
  draw(:b2b_authentication)
  draw(:b2b_magic_links)
  draw(:b2b_passwords)
  draw(:b2c_authentication)
  draw(:b2c_magic_links)
  draw(:b2c_passwords)
end
