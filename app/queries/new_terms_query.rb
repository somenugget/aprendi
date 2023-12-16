class NewTermsQuery < ApplicationQuery
  # @!method initialize(scope = Term.all, user:)

  param :scope, default: -> { Term.all }

  # @!method user
  option :user

  def relation
    TermsWithProgressQuery.new(scope, user: user).relation.where(term_progresses: { success_percentage: nil })
  end
end
