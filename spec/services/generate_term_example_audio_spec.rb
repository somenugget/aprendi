RSpec.describe GenerateTermExampleAudio do
  let(:term_example) { create(:term_example, term_lang: 'es', term_example: 'hola mundo') }
  let(:audio_client) { instance_double(OpenAI::Audio, speech: 'mp3-bytes') }
  let(:client) { instance_double(OpenAI::Client, audio: audio_client) }

  before do
    allow(OpenAI::Client).to receive(:new).and_return(client)
  end

  it 'attaches generated audio' do
    described_class.call(term_example: term_example)

    expect(term_example.term_example_audio).to be_attached
  end

  it 'stores the audio as an mp3' do
    described_class.call(term_example: term_example)

    expect(term_example.term_example_audio.blob.content_type).to eq('audio/mpeg')
  end

  it 'sends the example text to OpenAI speech generation' do
    described_class.call(term_example: term_example)

    expect(audio_client).to have_received(:speech).with(parameters: expected_parameters)
  end

  it 'does not call OpenAI when audio is already attached' do
    attached_example = attach_existing_audio
    described_class.call(term_example: attached_example)

    expect(audio_client).not_to have_received(:speech)
  end

  it 'regenerates existing audio when requested' do
    attached_example = attach_existing_audio
    described_class.call(term_example: attached_example, regenerate: true)

    expect(attached_example.reload.term_example_audio.download).to eq('mp3-bytes')
  end

  def attach_existing_audio
    TermExample.find(term_example.id).tap do |attached_example|
      attached_example.term_example_audio.attach(io: StringIO.new('existing'), filename: 'existing.mp3',
                                                 content_type: 'audio/mpeg')
    end
  end

  def expected_parameters
    {
      model: 'gpt-4o-mini-tts',
      voice: 'shimmer',
      instructions: 'Speak in Spanish. Pronounce the provided text using Spanish phonology only. ' \
                    'Do not use English pronunciation, even if words are spelled the same in English. ' \
                    'Say only the provided text, naturally and clearly.',
      response_format: 'mp3',
      input: 'hola mundo'
    }
  end
end
