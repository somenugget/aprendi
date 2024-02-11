class Users::SaveFromOmniauth < BaseService
  input :provider, type: String
  input :uid, type: String
  input :first_name, type: String, allow_nil: true
  input :last_name, type: String, allow_nil: true
  input :email, type: String, allow_nil: true

  # @return [User]
  def call
    authorization = find_authorization

    authorization ||= User.transaction do
      create_authorization(
        User.create!(
          first_name: first_name,
          last_name: last_name,
          password: password,
          email: email || User.email_placeholder
        )
      )
    end

    authorization.user
  end

  private

  def find_authorization
    Authorization.find_by(provider: provider, uid: uid)
  end

  def create_authorization(user)
    Authorization.create!(provider: provider, uid: uid, user: user)
  end

  def update_authorization_tokens(authorization)
    authorization.update!(
      token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token
    )
  end

  def password
    Devise.friendly_token[0, 20]
  end
end
