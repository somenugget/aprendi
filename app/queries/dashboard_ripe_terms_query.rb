class DashboardRipeTermsQuery < ApplicationQuery
  LOW_PROGRESS_TERMS_PERCENTAGE = 0.4
  RANDOM_TERMS_PERCENTAGE = 0.6

  # @!method initialize(scope = Term.all, user:, total_records: 5)

  param :scope, default: -> { Term.all }

  # @!method user
  # @return [User]
  option :user

  # @!method total_records
  # @return [Integer]
  option :total_records, default: -> { 5 }

  def relation
    freeze_sql_random

    (low_progress_terms + random_terms).sort_by(&:success_percentage)
  end

  private

  def ripe_terms
    @ripe_terms ||= RipeTermsQuery.new(scope, user: user).relation
  end

  def low_progress_terms
    @low_progress_terms ||= ripe_terms.first(total_records * LOW_PROGRESS_TERMS_PERCENTAGE)
  end

  def random_terms
    @random_terms ||= ripe_terms
                      .where
                      .not(id: low_progress_terms.map(&:id))
                      .reorder('random()')
                      .first(total_records * RANDOM_TERMS_PERCENTAGE)
  end

  # use setseed to make the random part of terms deterministic during the user's day
  def freeze_sql_random
    seed = DateTime.current.in_time_zone(user.settings.tz).day / 100.0
    ActiveRecord::Base.connection.execute("SELECT setseed(#{seed})")
  end
end
