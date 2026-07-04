require 'openai'

class GenerateTermAudio < BaseService
  input :term, type: Term

  MODEL = 'tts-1'.freeze
  DEFAULT_VOICE = 'alloy'.freeze
  VOICE_BY_TERM_LANG = {
    'en' => 'alloy',
    'es' => 'nova',
    'fr' => 'shimmer',
    'de' => 'onyx',
    'it' => 'fable',
    'pt' => 'nova',
    'uk' => 'shimmer',
    'ru' => 'onyx'
  }.freeze
  RESPONSE_FORMAT = 'mp3'.freeze
  CONTENT_TYPE = 'audio/mpeg'.freeze

  # Generate and attach cached speech for the term text.
  def call
    return if term.term_audio.attached?

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
    client.audio.speech(
      parameters: {
        model: MODEL,
        voice: voice,
        response_format: RESPONSE_FORMAT,
        input: term.term
      }
    )
  end

  def voice
    VOICE_BY_TERM_LANG.fetch(term_lang, DEFAULT_VOICE)
  end

  def term_lang
    term.study_set.study_config.term_lang
  end

  def client
    @client ||= OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_TOKEN'])
  end

  def filename
    "term-#{term.id}.#{RESPONSE_FORMAT}"
  end
end
