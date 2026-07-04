# frozen_string_literal: true

RSpec.describe TestSteps::PickDefinitionComponent, type: :component do
  let(:user) { create(:user) }
  let(:study_set) { create(:study_set, user:) }
  let(:test) { create(:test, user:) }
  let(:term) { create(:term, study_set:, term: 'hola') }
  let(:test_step) { create(:test_step, test:, term:, exercise: :pick_definition) }

  it 'renders the term title' do
    term.term_audio.attach(io: StringIO.new('mp3'), filename: 'term.mp3', content_type: 'audio/mpeg')

    rendered = render_inline(described_class.new(test_step:))

    expect(rendered.css('[data-testid="step_title"]').text).to include('hola')
  end

  it 'renders a title audio button when audio is attached' do
    term.term_audio.attach(io: StringIO.new('mp3'), filename: 'term.mp3', content_type: 'audio/mpeg')

    rendered = render_inline(described_class.new(test_step:))

    expect(rendered.css('[data-controller="audio-player"]').count).to eq(1)
  end
end
