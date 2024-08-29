class AccountDeletionRequestsController < ApplicationController
  skip_before_action :authenticate_with_token
  skip_before_action :authenticate_user!

  layout 'blog'

  def index; end

  def create
    email = params[:account_deletion_request][:email].to_s
    token = UserAuthToken.create_with_token(meta: { email: email })

    AccountDeletionMailer.confirmation(email, token).deliver_later

    redirect_to data_deletion_path, notice: I18n.t('account_deletion_requests.confirmation_sent')
  end

  def confirm
    result = Users::DeleteAccountByToken.result(token: params[:token])

    if result.success?
      flash.now[:success] = I18n.t('account_deletion_requests.success', email: result.output.email)
    else
      flash.now[:error] = result.error
    end
  end
end
