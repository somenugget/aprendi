class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[google_oauth2 facebook twitter]

  has_many :authorizations, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :tests, dependent: :destroy

  class << self
    def from_omniauth(auth)
      authorization = Authorization.where(
        provider: auth.provider,
        uid: auth.uid.to_s
      ).first_or_initialize

      if authorization.user.blank?
        user = User.find_or_initialize_by(email: auth.info.email)
        user.password = Devise.friendly_token[0, 20]
        user.email = auth.info.email
        authorization.user = user
      else
        user = authorization.user
      end

      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.save!
      authorization.save!

      authorization.update(
        token: auth.credentials.token,
        refresh_token: auth.credentials.refresh_token
      )

      authorization.user
    end
  end
end
