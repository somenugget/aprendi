class Users::DeleteAccountByToken < BaseService
  # @!method token
  # @return [String]
  input :token, type: String

  # find an email related to deletion token and delete the user
  def call
    UserAuthToken.find_by_token(token.to_s).tap do |token|
      if token
        email = token.email
        token.destroy

        user = User.find_by(email: email)

        if user
          user.destroy!
        else
          fail!(error: I18n.t('account_deletion_requests.errors.no_account', email:))
        end
      else
        fail!(error: I18n.t('account_deletion_requests.errors.confirmation'))
      end
    end
  end
end
