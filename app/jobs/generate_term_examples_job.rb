class GenerateTermExamplesJob < ApplicationJob
  queue_as :default

  discard_on ActiveRecord::RecordNotFound

  # @param [String] term_id
  def perform(term_id)
    term = Term.find(term_id)

    GenerateTermExamples.call(term: term)
  end
end
