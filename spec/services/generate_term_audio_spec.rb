RSpec.describe GenerateTermAudio do
  let(:user) { create(:user) }
  let(:study_set) { create(:study_set, user:) }
  let(:term) { create(:term, study_set:, term: 'hola') }
  let(:audio_client) { instance_double(OpenAI::Audio, speech: 'mp3-bytes') }
  let(:client) { instance_double(OpenAI::Client, audio: audio_client) }

  before do
    allow(OpenAI::Client).to receive(:new).and_return(client)
  end

  it 'attaches generated audio' do
    described_class.call(term:)

    expect(term.term_audio).to be_attached
  end

  it 'stores the audio as an mp3' do
    described_class.call(term:)

    expect(term.term_audio.blob.content_type).to eq('audio/mpeg')
  end

  it 'stores the generated audio bytes' do
    described_class.call(term:)

    expect(term.term_audio.download).to eq('mp3-bytes')
  end

  it 'sends the term text to OpenAI speech generation' do
    described_class.call(term:)

    expect(audio_client).to have_received(:speech).with(parameters: expected_parameters)
  end

  it 'has a voice mapping for every supported study config language' do
    expect(described_class::VOICE_BY_TERM_LANG.keys).to match_array(StudyConfig::LANGUAGES.keys)
  end

  it 'does not call OpenAI when audio is already attached' do
    attach_existing_audio
    described_class.call(term:)

    expect(audio_client).not_to have_received(:speech)
  end

  it 'keeps existing audio when audio is already attached' do
    attach_existing_audio
    described_class.call(term:)

    expect(term.term_audio.download).to eq('existing')
  end

  def attach_existing_audio
    term.term_audio.attach(io: StringIO.new('existing'), filename: 'existing.mp3', content_type: 'audio/mpeg')
  end

  def expected_parameters
    {
      model: 'tts-1',
      voice: 'nova',
      response_format: 'mp3',
      input: 'hola'
    }
  end
end
