class Users::SaveFromOmniauth < BaseService
  input :auth, type: OmniAuth::AuthHash

  # @return [User]
  def call
    authorization = find_authorization

    if authorization
      update_authorization_tokens(authorization)
    else
      user = User.find_or_initialize_by(email: auth.info.email)
      authorization = create_authorization(user)
    end

    authorization.user.update!(
      first_name: auth.info.first_name,
      last_name: auth.info.last_name
    )

    authorization.user
  end

  private

  def find_authorization
    Authorization.find_by(
      provider: auth.provider,
      uid: auth.uid.to_s
    )
  end

  def create_authorization(user)
    Authorization.create!(
      provider: auth.provider,
      uid: auth.uid.to_s,
      user: user,
      token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token
    )
  end

  def update_authorization_tokens(authorization)
    authorization.update!(
      token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token
    )
  end
end
