class UserAuthToken < ApplicationRecord
  belongs_to :user

  # @param [User] user
  # @param [ActiveSupport::TimeWithZone|DateTime] expires_at
  # @return [String]
  def self.create_for_user(user, expires_at = 1.day.from_now)
    SecureRandom.hex(16).tap do |token|
      create!(user:, expires_at:, token_hash: Digest::SHA1.hexdigest(token))
    end
  end

  # @param [String] token
  # @return [UserAuthToken|nil]
  def self.find_by_token(token)
    return if token.blank?

    find_by(token_hash: Digest::SHA1.hexdigest(token))
  end
end
