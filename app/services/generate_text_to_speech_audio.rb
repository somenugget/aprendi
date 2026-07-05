require 'openai'

class GenerateTextToSpeechAudio < BaseService
  input :text, type: String
  input :lang, type: String

  MODEL = 'gpt-4o-mini-tts'.freeze
  DEFAULT_VOICE = 'alloy'.freeze
  VOICE_BY_LANG = {
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

  output :audio_response, type: String

  # Generate speech audio for text.
  def call
    self.audio_response = client.audio.speech(parameters: speech_parameters)
  end

  private

  def speech_parameters
    {
      voice: voice,
      instructions: instructions,
      model: MODEL,
      response_format: RESPONSE_FORMAT,
      input: text,
    }.compact
  end

  def voice
    VOICE_BY_LANG.fetch(lang, DEFAULT_VOICE)
  end

  def language
    StudyConfig::LANGUAGES.fetch(lang)
  end

  def instructions
    return if lang == 'en'

    if word?
      word_instructions
    else
      text_instructions
    end
  end

  def word?
    text.split.one?
  end

  def word_instructions
    <<~INSTRUCTIONS.squish
      Speak in #{language}.
      Pronounce the target word using #{language} phonology only.
      Do not use English pronunciation, even if the word is spelled the same in English.
      Say only the target word, naturally and clearly.
    INSTRUCTIONS
  end

  def text_instructions
    <<~INSTRUCTIONS.squish
      Speak in #{language}.
      Pronounce the provided text using #{language} phonology only.
      Do not use English pronunciation, even if words are spelled the same in English.
      Say only the provided text, naturally and clearly.
    INSTRUCTIONS
  end

  def client
    @client ||= OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_TOKEN'])
  end
end
