class Users::SessionsController < Devise::SessionsController
  def new
    token = UserAuthToken.find_by_token params[:token]

    session[:telegram_user_id] = token.meta['telegram_user_id'] if token.present?

    super
  end
end
