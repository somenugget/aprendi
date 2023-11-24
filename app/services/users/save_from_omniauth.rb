class Users::SaveFromOmniauth < BaseService
  input :auth, type: OmniAuth::AuthHash

  # @return [User]
  def call
    authorization = find_authorization

    if authorization
      update_authorization_tokens(authorization)
    else
      authorization = create_authorization
    end

    authorization.user
  end

  private

  def user
    @user ||=
      User.find_or_initialize_by(email: auth.info.email).tap do |user|
        user.update!(
          first_name: auth.info.first_name,
          last_name: auth.info.last_name,
          **(user.new_record? ? { password: Devise.friendly_token[0, 10] } : {})
        )
      end
  end

  def find_authorization
    Authorization.find_by(
      provider: auth.provider,
      uid: auth.uid.to_s
    )
  end

  def create_authorization
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
