# frozen_string_literal: true

class StudySets::TopBarComponent < ApplicationComponent
  attr_reader :study_set

  def initialize(study_set:)
    @study_set = study_set
  end

  private

  def less_learnt_terms
    LessLearntTermsQuery.new(Term.where(study_set_id: @study_set)).relation
  end
end
