require 'openai'

class GenerateTermAudio < BaseService
  input :term, type: Term
  input :regenerate, type: [TrueClass, FalseClass], default: false

  MODEL = 'gpt-4o-mini-tts'.freeze
  DEFAULT_VOICE = 'alloy'.freeze
  VOICE_BY_TERM_LANG = {
    'en' => 'alloy',
    'es' => 'shimmer',
    'fr' => 'shimmer',
    'de' => 'onyx',
    'it' => 'fable',
    'pt' => 'coral',
    'uk' => 'shimmer',
    'ru' => 'onyx'
  }.freeze
  RESPONSE_FORMAT = 'mp3'.freeze
  CONTENT_TYPE = 'audio/mpeg'.freeze

  # Generate and attach cached speech for the term text.
  def call
    return if term.term_audio.attached? && !regenerate

    attach_audio
  end

  private

  def attach_audio
    term.term_audio.attach(
      io: StringIO.new(audio_response),
      filename: filename,
      content_type: CONTENT_TYPE
    )
  end

  def audio_response
    client.audio.speech(parameters: speech_parameters)
  end

  def voice
    VOICE_BY_TERM_LANG.fetch(term_lang, DEFAULT_VOICE)
  end

  def term_lang
    term.study_set.study_config.term_lang
  end

  def language
    StudyConfig::LANGUAGES.fetch(term_lang)
  end

  def instructions
    return if term_lang == 'en'

    <<~INSTRUCTIONS.squish
      Speak in #{language}.
      Pronounce the target word using #{language} phonology only.
      Do not use English pronunciation, even if the word is spelled the same in English.
      Say only the target word, naturally and clearly.
    INSTRUCTIONS
  end

  def speech_parameters
    {
      voice:,
      instructions:,
      model: MODEL,
      response_format: RESPONSE_FORMAT,
      input: term.term,
    }.compact
  end

  def client
    @client ||= OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_TOKEN'])
  end

  def filename
    "term-#{term.id}.#{RESPONSE_FORMAT}"
  end
end
