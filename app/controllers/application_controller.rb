class ApplicationController < ActionController::Base
  before_action :authenticate_user!, if: :should_authenticate?
  before_action :update_user_timezone

  def recent_test_in_progress
    @recent_test_in_progress ||= current_user.tests.in_progress.order(:id).first
  end
  helper_method :recent_test_in_progress

  def recent_test_step_in_progress
    @recent_test_step_in_progress ||= if recent_test_in_progress
                                        recent_test_in_progress
                                          .test_steps
                                          .not_finished
                                          .order(:id)
                                          .first
                                      end
  end
  helper_method :recent_test_step_in_progress

  def after_sign_in_path_for(user)
    if user.term_progresses.any?
      dashboard_path
    else
      folders_path
    end
  end

  private

  def update_user_timezone
    return unless current_user
    return if request.headers['HTTP_X_TIME_ZONE'].blank?
    return if current_user.updated_at.after?(1.day.ago)

    current_user.settings.update(tz: request.headers['HTTP_X_TIME_ZONE'])
  end

  def should_authenticate?
    return false if devise_controller?
    return false if controller_name == 'home'

    true
  end
end
