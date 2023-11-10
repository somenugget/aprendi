class ApplicationController < ActionController::Base
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
end
