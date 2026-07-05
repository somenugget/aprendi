class GenerateTermAudioJob < ApplicationJob
  queue_as :generate_terms

  discard_on ActiveRecord::RecordNotFound

  # @param [Integer] term_id
  # @param [Boolean] regenerate
  def perform(term_id, regenerate: false)
    term = Term.find(term_id)

    GenerateTermAudio.call(term: term, regenerate: regenerate)
  end
end
