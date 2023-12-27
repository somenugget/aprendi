class DashboardController < ApplicationController
  def index # rubocop:disable Metrics/AbcSize
    @ripening_terms = RipeningTermsQuery.new(user: current_user).relation.limit(5).load
    @new_terms_to_learn = NewTermsQuery.new(user: current_user).relation.order(:created_at).limit(5).load
    @ripe_terms_to_learn = DashboardRipeTermsQuery.new(user: current_user).relation
    @latest_folders = current_user.folders.order(created_at: :desc).limit(3).load
  end
end
