class GenerateTermExamplesJob < ApplicationJob
  queue_as :generate_terms

  discard_on ActiveRecord::RecordNotFound

  # @param [Integer] term_id
  # Schedules the job to be performed sometime in the next 0-120 seconds.
  def self.perform_sometime_later(term_id)
    set(wait: rand(0..120).seconds).perform_later(term_id)
  end

  # @param [Integer] term_id
  def perform(term_id)
    term = Term.find(term_id)

    GenerateTermExamples.call(term: term)
  end
end
