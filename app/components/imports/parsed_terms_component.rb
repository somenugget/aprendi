class Imports::ParsedTermsComponent < ApplicationComponent
  attr_reader :study_set, :terms

  # @param [StudySet] study_set
  # @param [Array<Imports::ParsedTerm>] terms
  def initialize(study_set, terms = [])
    @study_set = study_set
    @terms = terms
  end

  private

  def submit_disabled?
    terms.empty? || terms.any? { |term| term.errors[:term].any? || term.errors[:definition].any? }
  end
end
