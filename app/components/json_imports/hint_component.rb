# frozen_string_literal: true

class JSONImports::HintComponent < ApplicationComponent
  def initialize(study_set:)
    @study_set = study_set
  end
end
