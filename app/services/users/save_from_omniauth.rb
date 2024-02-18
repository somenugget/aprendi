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
      create_authorization
    end

    authorization.user
  end

  private

  def find_authorization
    Authorization.find_by(provider: provider, uid: uid)
  end

  def create_authorization
    Authorization.create!(provider: provider, uid: uid, user: find_or_create_user)
  end

  def find_or_create_user
    User.find_by(email: email) || User.create!(
      first_name: first_name,
      last_name: last_name,
      password: password,
      email: email || User.email_placeholder
    )
  end

  def password
    Devise.friendly_token[0, 20]
  end
end
