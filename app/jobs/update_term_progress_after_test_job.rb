class UpdateTermProgressAfterTestJob < ApplicationJob
  queue_as :default

  discard_on ActiveRecord::RecordNotFound

  # @param [Integer] test_id
  def perform(test_id)
    test = Test.find(test_id)

    test.terms.pluck(:id).each do |term_id|
      term_progress = TermProgress.find_or_create_by!(user_id: test.user_id, term_id: term_id)
      update_term_progress(term_progress, test)
    end
  end

  private

  def update_term_progress(term_progress, test)
    prev_weighted_success_percentage = term_progress.success_percentage * term_progress.tests_count
    current_term_success_percentage = test_term_success_percentage(test, term_progress.term_id)
    new_tests_count = term_progress.tests_count + 1
    new_success_percentage = (prev_weighted_success_percentage + current_term_success_percentage) / new_tests_count
    learnt = new_success_percentage >= 80 && new_tests_count > 4

    term_progress.update!(
      tests_count: new_tests_count,
      success_percentage: new_success_percentage,
      learnt: learnt,
      next_test_date: learnt ? nil : next_test_date(new_tests_count, new_success_percentage)
    )
  end

  def test_term_success_percentage(test, term_id)
    successful_count = test.test_steps.where(term_id: term_id).successful.count
    total_count = test.test_steps.where(term_id: term_id).count
    successful_count * 100 / total_count
  end

  def next_test_date(tests_count, success_percentage)
    case tests_count
    when 1
      1.day.from_now
    when 2
      3.days.from_now
    when 3
      7.days.from_now
    when 4
      fourth_test_date(success_percentage)
    else
      subsequent_test_date(success_percentage)
    end
  end

  def fourth_test_date(success_percentage)
    if success_percentage >= 75
      14.days.from_now
    else
      3.days.from_now
    end
  end

  def subsequent_test_date(success_percentage)
    if success_percentage > 80
      nil
    elsif success_percentage > 50
      7.days.from_now
    elsif success_percentage > 30
      3.days.from_now
    else
      2.days.from_now
    end
  end
end
