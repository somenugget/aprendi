# frozen_string_literal: true

class JSONImports::FormComponent < ApplicationComponent
  def initialize(study_set:, file_error: nil, string_error: nil)
    @study_set = study_set
    @file_error = file_error
    @string_error = string_error
  end
end
