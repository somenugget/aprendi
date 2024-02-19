class Term < ApplicationRecord
  belongs_to :study_set, touch: true

  has_many :term_example_terms, dependent: :destroy
  has_many :term_examples, through: :term_example_terms
  has_many :test_steps, dependent: :destroy

  has_one :term_progress, dependent: :destroy

  validates :term, presence: true
  validates :definition, presence: true

  scope :with_progress,
        -> { left_joins(:term_progress).select('COALESCE(term_progresses.success_percentage, 0) AS progress, terms.*') }

  normalizes :term, :definition, with: -> { _1.downcase.strip.squish }

  # @return [Boolean]
  def long_phrase?
    term.split.count >= 6
  end
end
