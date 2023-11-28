class DashboardController < ApplicationController
  # rubocop:disable Layout/LineLength
  def index # rubocop:disable Metrics/AbcSize
    terms_base = Term.where(study_set_id: current_user.study_sets)
                     .joins(term_progresses_join_sql)
                     .select('terms.*, term_progresses.tests_count, term_progresses.success_percentage, term_progresses.next_test_date')

    new_terms_to_learn_base = terms_base.where('term_progresses.success_percentage IS NULL')

    ripe_terms_to_learn_base = terms_base.where("DATE_TRUNC('day', term_progresses.next_test_date) <= NOW() AND term_progresses.learnt = FALSE")
                                         .where.not(id: new_terms_to_learn_base.reselect('id'))
                                         .order('term_progresses.success_percentage NULLS FIRST, term_progresses.next_test_date NULLS FIRST, terms.created_at')

    @ripening_terms = terms_base.where.not(id: new_terms_to_learn_base.reselect('id'))
                                .where.not(id: ripe_terms_to_learn_base.reselect('id'))
                                .order('term_progresses.success_percentage NULLS FIRST, term_progresses.next_test_date NULLS FIRST')
                                .limit(5)
                                .load

    @new_terms_to_learn = new_terms_to_learn_base.order(:created_at).limit(5).load
    @ripe_terms_to_learn = ripe_terms_to_learn_base.limit(5).load
    @latest_folders = current_user.folders.order(created_at: :desc).limit(3).load
  end
  # rubocop:enable Layout/LineLength

  private

  def term_progresses_join_sql
    <<~SQL
      LEFT JOIN term_progresses ON terms.id = term_progresses.term_id AND term_progresses.user_id = #{current_user.id}
    SQL
  end
end
