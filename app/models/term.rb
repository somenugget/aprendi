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

  normalizes :term, :definition, with: -> { NormalizeWord.downcase_preserving_acronyms(it) }

  class << self
    # is char that should be guessed
    def char_to_guess?(char)
      char.match?(/\p{L}/)
    end
  end

  # term's chars
  def chars
    term.downcase.chars
  end

  # all chars that should be guessed
  def chars_to_guess
    chars.select { |char| self.class.char_to_guess?(char) }
  end

  # array of chars to guess with their indexes
  # @return [Array<Hash{Symbol => Integer, String}>]
  def chars_to_guess_with_indexes
    chars_to_guess.map.with_index { |char, index| { char:, index: } }
  end
end
