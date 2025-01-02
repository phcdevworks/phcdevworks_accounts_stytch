class PhcdevworksAccountsStytch::Authentication::B2b::PasswordService
  def initialize(client:)
    @client = client
  end

  def create_password(organization_id:, email:, password:)
    @client.passwords.create(
      organization_id: organization_id,
      email: email,
      password: password
    )
  end

  def authenticate_password(organization_id:, email:, password:)
    @client.passwords.authenticate(
      organization_id: organization_id,
      email: email,
      password: password
    )
  end

  def reset_password(organization_id:, email:, reset_token:, new_password:)
    @client.passwords.reset(
      organization_id: organization_id,
      email: email,
      reset_token: reset_token,
      new_password: new_password
    )
  end
end
