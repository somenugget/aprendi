class LessLearntTermsQuery < ApplicationQuery
  # @!method initialize(scope = Term.all, terms_group_limit: 5)
  param :scope, default: -> { Term.all }

  # @!method terms_group_limit
  # @return [Integer]
  option :terms_group_limit, default: -> { 5 }

  def relation
    scope
      .with(numbered: numbered_terms_subquery)
      .joins('INNER JOIN numbered ON numbered.id = terms.id')
      .where('numbered.row_number <= ?', terms_group_limit)
  end

  private

  def numbered_terms_subquery
    scope
      .with_progress
      .merge(TermProgress.not_learnt)
      .select('ROW_NUMBER() OVER (PARTITION BY study_set_id ORDER BY success_percentage NULLS FIRST) AS row_number')
  end
end
