class UserAuthToken < ApplicationRecord
  belongs_to :user, optional: true

  store_accessor :meta, :email

  # @param [User] user
  # @param [ActiveSupport::TimeWithZone|DateTime] expires_at
  # @return [String]
  def self.create_for_user(user, expires_at = 1.day.from_now, **)
    create_with_token(expires_at:, user:, **)
  end

  # @return [String]
  def self.create_with_token(expires_at: 1.day.from_now, **rest)
    SecureRandom.hex(16).tap do |token|
      create!(expires_at:, **rest, token_hash: Digest::SHA1.hexdigest(token))
    end
  end

  # @param [String] token
  # @return [UserAuthToken|nil]
  def self.find_by_token(token)
    return if token.blank?

    find_by(token_hash: Digest::SHA1.hexdigest(token))
  end
end
