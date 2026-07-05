class GenerateTermExampleAudio < BaseService
  input :term_example, type: TermExample
  input :regenerate, type: [TrueClass, FalseClass], default: false

  # Generate and attach cached speech for the example text.
  def call
    return if term_example.term_example_audio.attached? && !regenerate

    term_example.term_example_audio.attach(
      io: StringIO.new(audio_response),
      filename: filename,
      content_type: GenerateTextToSpeechAudio::CONTENT_TYPE
    )
  end

  private

  def audio_response
    GenerateTextToSpeechAudio.call(text: term_example.term_example, lang: term_example.term_lang).audio_response
  end

  def filename
    "term-example-#{term_example.id}.#{GenerateTextToSpeechAudio::RESPONSE_FORMAT}"
  end
end
