class StudyConfig < ApplicationRecord
  belongs_to :configurable, polymorphic: true

  LANGUAGES = %w[en es fr de it pt uk ru].freeze
end
