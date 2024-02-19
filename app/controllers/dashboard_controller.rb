class DashboardController < ApplicationController
  # using .load to avoid making the second query when calling .any? in views
  def index # rubocop:disable Metrics/AbcSize
    return render('index_no_progress') unless any_progress?

    @ripening_terms = RipeningTermsQuery.new(user: current_user).relation.limit(5).load
    @ripening_terms_count = RipeningTermsQuery.new(user: current_user).count
    @new_terms_to_learn = NewTermsQuery.new(user: current_user).relation.order(:created_at).limit(5).load
    @new_terms_to_learn_count = NewTermsQuery.new(user: current_user).count
    @ripe_terms_to_learn = DashboardRipeTermsQuery.new(user: current_user).relation
    @ripe_terms_to_learn_count = RipeTermsQuery.new(user: current_user).count
    @latest_folders = current_user.folders.order(created_at: :desc).limit(3).load

    @less_studied_study_sets = less_studied_study_sets
    @terms_for_less_studied_study_sets = terms_for_less_studied_study_sets(@less_studied_study_sets)
  end

  private

  def any_progress?
    TermProgress.where(user: current_user).any?
  end

  def less_studied_study_sets
    StudySetsWithProgressQuery
      .new(user: current_user)
      .relation
      .order(pinned: :desc, progress: :asc, updated_at: :asc)
      .limit(6)
      .load
  end

  # @param [ActiveRecord::Relation<StudySet>] less_studied_study_sets
  def terms_for_less_studied_study_sets(less_studied_study_sets)
    LessLearntTermsQuery
      .new(Term.where(study_set_id: less_studied_study_sets.pluck(:id)))
      .relation
      .group_by(&:study_set_id)
  end
end
