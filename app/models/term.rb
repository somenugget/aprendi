class Term < ApplicationRecord
  belongs_to :folder
  belongs_to :study_set

  validates :term, presence: true
  validates :definition, presence: true

  normalizes :term, :definition, with: -> { _1.downcase.strip.squish }
end
