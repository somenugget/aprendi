# frozen_string_literal: true

RSpec.describe TestSteps::ExamplesComponent, type: :component do
  let(:user) { create(:user) }
  let(:study_set) { create(:study_set, user: user) }
  let(:term) { create(:term, study_set: study_set) }
  let(:term_example) { create(:term_example, terms: [term], term_example: 'hola mundo') }

  it 'renders an example audio button when audio is attached' do
    term_example.term_example_audio.attach(io: StringIO.new('mp3'), filename: 'example.mp3', content_type: 'audio/mpeg')

    rendered = render_inline(described_class.new(term: term))

    expect(rendered.css('[data-audio-player-url-value]').first['data-audio-player-url-value']).to eq(
      Rails.application.routes.url_helpers.term_example_audio_path(term_example)
    )
  end
end
