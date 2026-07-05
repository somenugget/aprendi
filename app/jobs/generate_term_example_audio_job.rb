class GenerateTermExampleAudioJob < ApplicationJob
  queue_as :generate_terms

  discard_on ActiveRecord::RecordNotFound

  # @param [Integer] term_example_id
  # @param [Boolean] regenerate
  def perform(term_example_id, regenerate: false)
    term_example = TermExample.find(term_example_id)

    GenerateTermExampleAudio.call(term_example: term_example, regenerate: regenerate)
  end
end
