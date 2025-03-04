class StreakComponent < ApplicationComponent
  # @param [User] user
  def initialize(user:)
    @user = user
  end

  private

  def render?
    @user.streak.present?
  end

  def streak_today?
    @user.streak.last_activity_date == Date.current
  end

  def current_streak
    @user.streak.current_streak
  end
end
