class SettingsController < ApplicationController
  def show
    @settings = current_user.settings
  end

  def update
    @settings = current_user.settings

    if @settings.update(settings_params)
      redirect_to settings_path, notice: 'Settings were updated.', status: :see_other
    else
      render :show, status: :unprocessable_content
    end
  end

  private

  def settings_params
    params
      .expect(
        user_settings: %i[term_lang definition_lang daily_reminder weekly_reminder push_notifications enable_folders]
      )
  end
end
