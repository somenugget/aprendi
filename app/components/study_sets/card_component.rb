class StudySets::CardComponent < ApplicationComponent
  extend Dry::Initializer

  # @!method initialize(study_set:)

  # @!method study_set
  #  @return [StudySet]
  option :study_set
end
