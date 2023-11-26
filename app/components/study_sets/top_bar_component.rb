# frozen_string_literal: true

class StudySets::TopBarComponent < ApplicationComponent
  attr_reader :study_set

  def initialize(study_set:)
    @study_set = study_set
  end
end
