class ReminderMailer < ApplicationMailer
  # @param [User] user
  def daily(user)
    mail(to: user.email, subject: "Adrendí: Daily reminder #{DateTime.current}")
  end
end
