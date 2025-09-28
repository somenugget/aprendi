class Users::UpdateStreak < BaseService
  input :user, type: User

  # @return [Boolean]
  # @!method streak_extended
  output :streak_extended

  # Update or create user's streak
  def call
    return if already_logged_today?

    ActiveRecord::Base.transaction do
      ensure_streak_exists!

      log_today_activity
      update_streak
    end
  end

  private

  def current_date
    @current_date ||= Date.current
  end

  def ensure_streak_exists!
    user.streak ||= user.create_streak!
  end

  def already_logged_today?
    user.streak_logs.exists?(activity_date: current_date)
  end

  def log_today_activity
    user.streak_logs.create!(activity_date: current_date)
  end

  def update_streak # rubocop:disable Metrics/AbcSize
    previous_date = current_date - 1.day

    if user.streak.last_activity_date.nil? || user.streak.last_activity_date == previous_date
      user.streak.current_streak += 1
      self.streak_extended = true
    elsif user.streak.last_activity_date < previous_date
      user.streak.current_streak = 1 # Reset if a day was skipped
      self.streak_extended = false
    end

    user.streak.longest_streak = [user.streak.longest_streak, user.streak.current_streak].max
    user.streak.last_activity_date = current_date
    user.streak.save!
  end
end
