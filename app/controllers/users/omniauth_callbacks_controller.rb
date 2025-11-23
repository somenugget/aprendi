module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token

    def google_oauth2 # rubocop:disable Metrics/AbcSize
      if request.env['omniauth.auth']['extra']['aud'] != ENV['GOOGLE_CLIENT_ID']
        Rails.logger.info "Omniauth AUD error: #{request.env['omniauth.auth'].inspect}"
        return redirect_to new_user_session_url
      end

      @user = login_user_using('google_oauth2')

      if @user.persisted?
        return connect_telegram_and_redirect if session[:telegram_user_id].present?

        sign_in_and_redirect @user, event: :authentication
      else
        redirect_to new_user_session_url, alert: @user.errors.full_messages.join("\n")
      end
    end

    def facebook
      login_using('facebook')
    end

    private

    def connect_telegram_and_redirect
      Users::SaveFromOmniauth.call(
        email: @user.email,
        uid: session[:telegram_user_id].to_s,
        provider: 'telegram',
        first_name: nil,
        last_name: nil
      )

      session.delete(:telegram_user_id)

      redirect_to telegram_redirect_path
    end

    def login_using(provider)
      @user = login_user_using(provider)

      if @user.persisted?
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
