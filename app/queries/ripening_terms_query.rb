class RipeningTermsQuery < ApplicationQuery
  # @!method initialize(scope = Term.all, user:)

  param :scope, default: -> { Term.all }

  # @!method user
  option :user

  def relation
    TermsWithProgressQuery
      .new(scope, user: user).relation
      .where.not(id: new_terms_to_learn_base.reselect('id'))
      .where.not(id: ripe_terms_to_learn_base.reselect('id'))
      .order('term_progresses.success_percentage NULLS FIRST, term_progresses.next_test_date NULLS FIRST')
  end

  private

  def new_terms_to_learn_base
    NewTermsQuery.new(scope, user: user).relation
  end

  def ripe_terms_to_learn_base
    RipeTermsQuery.new(scope, user: user).relation
  end
end
