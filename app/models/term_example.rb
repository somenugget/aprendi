class TermExample < ApplicationRecord
  validates :term, :definition, :term_lang, :definition_lang, :term_example, :definition_example, presence: true

  normalizes :term,
             :definition,
             :term_lang,
             :definition_lang,
             :term_example,
             :definition_example,
             with: -> { it.downcase.squish }

  has_many :term_example_terms, dependent: :destroy
  has_many :terms, through: :term_example_terms
end
