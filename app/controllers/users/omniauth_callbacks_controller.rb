module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token

    def google_oauth2
      login_using('google_oauth2')
    end

    def facebook
      login_using('facebook')
    end

    private

    def login_using(provider)
      @user = login_user_using(provider)

      if @user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: provider
        sign_in_and_redirect @user, event: :authentication
      else
        redirect_to new_user_session_url, alert: @user.errors.full_messages.join("\n")
      end
    end

    def login_user_using(kind)
      Users::SaveFromOmniauth.call(
        **UserParamsFromAuth.call(auth: request.env['omniauth.auth'], provider: kind).output
      ).output
    end

    def after_omniauth_failure_path_for(_scope)
      new_user_session_path
    end
  end
end
