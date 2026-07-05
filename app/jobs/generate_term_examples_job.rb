class GenerateTermExamplesJob < ApplicationJob
  queue_as :generate_terms

  discard_on ActiveRecord::RecordNotFound

  # @param [Integer] term_id
  def perform(term_id, regenerate: false)
    term = Term.find(term_id)

    GenerateTermExamples.call(term: term, regenerate: regenerate)
  end
end
