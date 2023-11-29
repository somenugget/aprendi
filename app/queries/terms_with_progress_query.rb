class TermsWithProgressQuery < ApplicationQuery
  # @!method initialize(scope=Term.all, user:)

  # @!method scope
  # @return [ActiveRecord::Relation<Term>]
  param :scope, default: -> { Term.all }

  # @!method user
  # @return [User]
  option :user

  def filter_user(scope)
    scope.where(study_set_id: user.study_sets)
  end

  def relation
    super.joins(term_progresses_join_sql)
         .select('terms.*, term_progresses.tests_count, term_progresses.success_percentage, term_progresses.next_test_date')
  end

  private

  def term_progresses_join_sql
    <<~SQL
      LEFT JOIN term_progresses ON terms.id = term_progresses.term_id AND term_progresses.user_id = #{user.id}
    SQL
  end
end
