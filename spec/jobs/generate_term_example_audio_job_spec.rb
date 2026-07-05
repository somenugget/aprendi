RSpec.describe GenerateTermExampleAudioJob do
  let(:term_example) { create(:term_example) }

  it 'generates audio for the term example' do
    allow(GenerateTermExampleAudio).to receive(:call)

    described_class.perform_now(term_example.id)

    expect(GenerateTermExampleAudio).to have_received(:call).with(term_example: term_example, regenerate: false)
  end

  it 'passes regeneration through to the service' do
    allow(GenerateTermExampleAudio).to receive(:call)

    described_class.perform_now(term_example.id, regenerate: true)

    expect(GenerateTermExampleAudio).to have_received(:call).with(term_example: term_example, regenerate: true)
  end
end
