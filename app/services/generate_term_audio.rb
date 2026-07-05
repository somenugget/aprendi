class GenerateTermAudio < BaseService
  input :term, type: Term
  input :regenerate, type: [TrueClass, FalseClass], default: false

  # Generate and attach cached speech for the term text.
  def call
    return if term.term_audio.attached? && !regenerate

    term.term_audio.attach(
      io: StringIO.new(audio_response),
      filename: filename,
      content_type: GenerateTextToSpeechAudio::CONTENT_TYPE
    )
  end

  private

  def audio_response
    GenerateTextToSpeechAudio.call(text: term.term, lang: term_lang).audio_response
  end

  def term_lang
    term.study_set.study_config.term_lang
  end

  def filename
    "term-#{term.id}.#{GenerateTextToSpeechAudio::RESPONSE_FORMAT}"
  end
end
