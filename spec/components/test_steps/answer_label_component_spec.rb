# frozen_string_literal: true

RSpec.describe TestSteps::AnswerLabelComponent, type: :component do
  let(:user) { create(:user) }
  let(:study_set) { create(:study_set, user:) }
  let(:term) { create(:term, study_set:, term: 'hola') }

  it 'does not render an audio button by default' do
    term.term_audio.attach(io: StringIO.new('mp3'), filename: 'term.mp3', content_type: 'audio/mpeg')

    rendered = render_inline(described_class.new(term:, label: term.term))

    expect(rendered.css('[data-controller="audio-player"]')).to be_empty
  end

  it 'renders an audio button when requested and audio is attached' do
    term.term_audio.attach(io: StringIO.new('mp3'), filename: 'term.mp3', content_type: 'audio/mpeg')

    rendered = render_inline(described_class.new(term:, label: term.term, play_audio: true))

    expect(rendered.css('[data-controller="audio-player"]').count).to eq(1)
  end

  it 'sets the audio button url' do
    term.term_audio.attach(io: StringIO.new('mp3'), filename: 'term.mp3', content_type: 'audio/mpeg')

    rendered = render_inline(described_class.new(term:, label: term.term, play_audio: true))
    audio_path = Rails.application.routes.url_helpers.term_audio_path(term)

    expect(rendered.css("[data-audio-player-url-value=\"#{audio_path}\"]").count).to eq(1)
  end
end
