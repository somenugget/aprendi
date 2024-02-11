class ApplicationController < ActionController::Base
  include ActionView::RecordIdentifier

  before_action :authenticate_user!, if: :should_authenticate?
  before_action :update_user_timezone

  def unfinished_test
    @unfinished_test ||= current_user.tests.recent_in_progress.first.then do |test|
      test && test.id.to_s == params[:test_id] ? nil : test
    end
  end
  helper_method :unfinished_test

  def unfinished_test_step
    @unfinished_test_step ||= if unfinished_test.present?
                                unfinished_test
                                  .test_steps
                                  .not_finished
                                  .order(:id)
                                  .first
                              end
  end

  helper_method :unfinished_test_step

  def after_sign_in_path_for(user)
    if user.term_progresses.any?
      dashboard_path
    else
      folders_path
    end
  end

  private

  def cached(key, **cache_options, &block)
    default_expiration = Rails.env.development? ? 1.second : 5.minutes

    Rails.cache.fetch(key, { expires_in: default_expiration, **cache_options }, &block)
  end

  def update_user_timezone
    return unless current_user
    return if browser_timezone.blank?
    return if current_user.settings.updated_at.after?(1.day.ago)

    current_user.settings.update(tz: browser_timezone)
  end

  def browser_timezone
    request.headers['HTTP_X_TIME_ZONE']
  end

  def should_authenticate?
    return false if devise_controller?
    return false if controller_name == 'home'

    true
  end

  def to_bool(value)
    ActiveModel::Type::Boolean.new.cast(value)
  end
end
