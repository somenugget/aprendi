class GenerateTermExamplesJob < ApplicationJob
  queue_as :generate_terms

  retry_on StandardError, wait: 5.minutes, attempts: 3

  discard_on ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid

  # @param [String] term_id
  def perform(term_id)
    term = Term.find(term_id)

    GenerateTermExamples.call(term: term)
  end
end
