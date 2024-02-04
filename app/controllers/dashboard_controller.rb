class DashboardController < ApplicationController
  # using .load to avoid making the second query when calling .any? in views
  def index # rubocop:disable Metrics/AbcSize
    @ripening_terms = RipeningTermsQuery.new(user: current_user).relation.limit(5).load
    @ripening_terms_count = RipeningTermsQuery.new(user: current_user).count
    @new_terms_to_learn = NewTermsQuery.new(user: current_user).relation.order(:created_at).limit(5).load
    @new_terms_to_learn_count = NewTermsQuery.new(user: current_user).count
    @ripe_terms_to_learn = DashboardRipeTermsQuery.new(user: current_user).relation
    @ripe_terms_to_learn_count = RipeTermsQuery.new(user: current_user).count
    @latest_folders = current_user.folders.order(created_at: :desc).limit(3).load

    @less_studied_study_sets = StudySetsWithProgressQuery
                               .new(user: current_user).relation.order(:progress, :created_at).limit(5).load
    @terms_for_less_studied_study_sets = LessLearntTermsQuery
                                         .new(Term.where(study_set_id: @less_studied_study_sets.pluck(:id)))
                                         .relation
                                         .group_by(&:study_set_id)
  end
end
