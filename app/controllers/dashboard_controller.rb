class DashboardController < ApplicationController
  def index
    terms_base = Term.where(study_set_id: current_user.study_sets)
                     .joins(term_progresses_join_sql)
                     .select('terms.*, term_progresses.tests_count, term_progresses.success_percentage, term_progresses.next_test_date')

    @new_terms_to_learn = terms_base.where('term_progresses.success_percentage IS NULL').load

    @ripe_terms_to_learn = terms_base.where("DATE_TRUNC('day', term_progresses.next_test_date) <= NOW() AND term_progresses.learnt = FALSE")
                                     .where.not(id: @new_terms_to_learn.map(&:id))
                                     .order('term_progresses.success_percentage NULLS FIRST, term_progresses.next_test_date NULLS FIRST, terms.created_at')
                                     .limit(5)
                                     .load

    @ripening_terms = terms_base.where.not(id: @new_terms_to_learn.map(&:id))
                                .where.not(id: @ripe_terms_to_learn.map(&:id))
                                .order(created_at: :desc)
                                .limit(5)
                                .load

    @latest_folders = current_user.folders.order(created_at: :desc).limit(3).load
  end

  private

  def term_progresses_join_sql
    <<~SQL
      LEFT JOIN term_progresses ON terms.id = term_progresses.term_id AND term_progresses.user_id = #{current_user.id}
    SQL
  end
end
