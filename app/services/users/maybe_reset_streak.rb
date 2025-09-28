class Users::MaybeResetStreak < BaseService
  input :user, type: User

  # Reset user's streak if they missed a day
  def call
    return unless streak_exists?
    return if already_logged_today?
    return if last_activity_date >= (Date.current - 1.day)

    user.streak.update!(current_streak: 0)
  end

  private

  def current_date
    @current_date ||= Date.current
  end

  def ensure_streak_exists!
    user.streak ||= user.create_streak!
  end

  def last_activity_date
    user.streak.last_activity_date
  end

  def already_logged_today?
    user.streak_logs.exists?(activity_date: current_date)
  end

  def streak_exists?
    user.streak.present? && last_activity_date.present?
  end
end
