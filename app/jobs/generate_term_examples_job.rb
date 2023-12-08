class GenerateTermExamplesJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  queue_as :generate_terms

  retry_on StandardError, wait: 5.minutes, attempts: 3

  discard_on ActiveRecord::RecordNotFound

  good_job_control_concurrency_with(
    perform_limit: 2,
    key: -> { 'GenerateTermExamplesJob' }
  )

  # @param [String] term_id
  def perform(term_id)
    term = Term.find(term_id)

    GenerateTermExamples.call(term: term)
  end
end
