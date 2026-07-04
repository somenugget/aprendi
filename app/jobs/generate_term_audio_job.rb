class GenerateTermAudioJob < ApplicationJob
  queue_as :generate_terms

  discard_on ActiveRecord::RecordNotFound

  # Schedules the job to be performed sometime in the next 0-120 seconds.
  def self.perform_sometime_later(term_id, regenerate: false)
    set(wait: rand(0..120).seconds).perform_later(term_id, regenerate: regenerate)
  end

  # @param [Integer] term_id
  # @param [Boolean] regenerate
  def perform(term_id, regenerate: false)
    term = Term.find(term_id)

    GenerateTermAudio.call(term: term, regenerate: regenerate)
  end
end
