RSpec.describe GenerateTermAudioJob do
  let(:user) { create(:user) }
  let(:study_set) { create(:study_set, user:) }
  let(:term) { create(:term, study_set:) }

  it 'generates audio for the term' do
    allow(GenerateTermAudio).to receive(:call)

    described_class.perform_now(term.id)

    expect(GenerateTermAudio).to have_received(:call).with(term:)
  end
end
