class Term < ApplicationRecord
  belongs_to :folder
  belongs_to :study_set

  has_many :term_example_terms, dependent: :destroy
  has_many :term_examples, through: :term_example_terms

  validates :term, presence: true
  validates :definition, presence: true

  normalizes :term, :definition, with: -> { _1.downcase.strip.squish }
end
