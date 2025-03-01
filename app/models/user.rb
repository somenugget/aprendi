class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[google_oauth2 facebook twitter]

  has_many :authorizations, dependent: :destroy
  has_many :study_sets, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :tests, dependent: :destroy
  has_many :term_progresses, dependent: :destroy
  has_many :push_subscriptions, dependent: :destroy
  has_many :account_deletion_requests, dependent: :destroy
  has_many :user_auth_tokens, dependent: :destroy
  has_many :streak_logs, dependent: :destroy

  has_one :settings, class_name: 'UserSettings', touch: true, dependent: :destroy
  has_one :streak, dependent: :destroy

  # Fake email for users who sign up via OAuth
  # @return [String]
  def self.email_placeholder
    "email_placeholder+#{SecureRandom.hex(4)}@example.com"
  end

  # @return [UserSettings]
  def settings
    super || create_settings!
  end

  # @return [PushSubscription, nil]
  def recent_subscription
    push_subscriptions.recent.order(last_seen_at: :desc).first
  end
end
