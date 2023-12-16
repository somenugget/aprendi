class DailyReminderJob < ApplicationJob
  queue_as :default

  SENDING_HOUR = ENV.fetch('DAILY_REMINDER_SENDING_HOUR', 9).to_i
  SENDING_THRESHOLD = 20.minutes

  # check if it's time to send user a reminder
  def perform
    job_start_time = DateTime.current

    each_user_with_daily_reminder do |user|
      next if user.settings.tz.blank?

      current_time_in_user_tz = job_start_time.in_time_zone(user.settings.tz)

      # TODO: extract to the method all the criterias for the reminder to be sent
      # timezone
      # correct time
      # presence of words to learn # extract from mailer
      ReminderMailer.daily(user).deliver_later if time_to_send?(current_time_in_user_tz)
    end
  end

  private

  def each_user_with_daily_reminder(&)
    User.joins(:settings).where(user_settings: { daily_reminder: true }).find_each(&)
  end

  def time_to_send?(current_time_in_user_tz)
    current_time_in_user_tz.change(hour: SENDING_HOUR).in?(
      (current_time_in_user_tz - SENDING_THRESHOLD)..(current_time_in_user_tz + SENDING_THRESHOLD)
    )
  end
end
