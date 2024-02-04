class StudySetsWithProgressQuery < ApplicationQuery
  # @!method initialize(scope = Term.all, user:)

  param :scope, default: -> { StudySet.all }

  # @!method user
  # @return [User]
  option :user

  def relation
    scope
      .where(user: user)
      .select('*, study_sets_progress.progress')
      .with(
        study_sets_progress: study_sets_progress
      )
      .joins('INNER JOIN study_sets_progress ON study_sets.id = study_sets_progress.study_set_id')
      .where(study_sets_progress: { progress: ...100 })
  end

  private

  def study_sets_progress
    StudySet.left_joins(terms: :term_progress)
            .select(
              <<~SQL.squish
                study_set_id,
                AVG(
                  CASE WHEN term_progresses.learnt = TRUE THEN 100
                  ELSE COALESCE(term_progresses.success_percentage, 0)
                  END
                ) AS progress
              SQL
            )
            .group(:study_set_id)
  end
end
