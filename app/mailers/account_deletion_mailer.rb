class AccountDeletionMailer < ApplicationMailer
  # @param [String] email of the user to delete
  # @param [String] token for the confirmation
  def confirmation(email, token)
    @email = email
    @token = token

    mail(to: email, subject: 'Adrendí: Account deletion confirmation')
  end
end
