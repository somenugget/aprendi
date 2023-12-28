class DashboardController < ApplicationController
  def index # rubocop:disable Metrics/AbcSize
    @ripening_terms = RipeningTermsQuery.new(user: current_user).relation.limit(5).load
    @ripening_terms_count = RipeningTermsQuery.new(user: current_user).count
    @new_terms_to_learn = NewTermsQuery.new(user: current_user).relation.order(:created_at).limit(5).load
    @new_terms_to_learn_count = NewTermsQuery.new(user: current_user).count
    @ripe_terms_to_learn = DashboardRipeTermsQuery.new(user: current_user).relation
    @ripe_terms_to_learn_count = RipeTermsQuery.new(user: current_user).count
    @latest_folders = current_user.folders.order(created_at: :desc).limit(3).load
  end
end
