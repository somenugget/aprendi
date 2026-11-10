class ReminderMailer < ApplicationMailer
  # @param [User] user
  def daily(user)
    @user = user
    @new_terms_to_learn = NewTermsQuery.new(user: @user).relation.order(:created_at).limit(5).load
    @ripe_terms_to_learn = RipeTermsQuery.new(user: @user).relation.limit(5).load

    return if @new_terms_to_learn.empty? && @ripe_terms_to_learn.empty?

    @login_token = UserAuthToken.create_for_user(user, meta: { purpose: 'reminder_login' })

    mail(to: user.email, subject: 'Adrendí: Daily reminder')
  end
end
