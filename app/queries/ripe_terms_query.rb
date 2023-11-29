class RipeTermsQuery < ApplicationQuery
  # @!method initialize(scope = Term.all, user:)

  param :scope, default: -> { Term.all }

  # @!method user
  option :user

  def relation
    new_terms_to_learn_base = NewTermsQuery.new(scope, user: user).relation

    TermsWithProgressQuery
      .new(scope, user: user).relation
      .where("DATE_TRUNC('day', term_progresses.next_test_date) <= NOW() AND term_progresses.learnt = FALSE")
      .where.not(id: new_terms_to_learn_base.reselect('id'))
      .order('term_progresses.success_percentage NULLS FIRST, term_progresses.next_test_date NULLS FIRST, terms.created_at')
  end
end
