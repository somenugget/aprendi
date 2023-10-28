class StudyConfig < ApplicationRecord
  belongs_to :configurable, polymorphic: true
end
