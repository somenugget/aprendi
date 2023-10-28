module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token

    def google_oauth2 # rubocop:disable Metrics/AbcSize
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, event: :authentication
      else
        # Removing extra as it can overflow some session stores
        session['devise.google_data'] = request.env['omniauth.auth'].except('extra')
        redirect_to new_user_session_url, alert: @user.errors.full_messages.join("\n")
      end
    end

    private

    def after_omniauth_failure_path_for(_scope)
      auth_path
    end
  end
end
