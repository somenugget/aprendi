class StreakComponent < ApplicationComponent
  # @param [User] user
  def initialize(user:)
    @user = user
  end

  private

  def render?
    @user.streak.present?
  end

  def test_completed_today?
    @user.streak.last_activity_date == Date.current
  end

  def current_streak
    @user.streak.current_streak
  end

  def tooltip_title
    test_completed_today? ? 'You have already completed your daily goal' : 'Exercise today to extend your streak'
  end
end
