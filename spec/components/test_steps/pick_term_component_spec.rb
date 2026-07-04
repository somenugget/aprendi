# frozen_string_literal: true

RSpec.describe TestSteps::PickTermComponent, type: :component do
  let(:test) { create(:test, user:) }
  let!(:correct_term) { create(:term, study_set:, term: 'hola') }
  let!(:other_terms) { create_list(:term, 3, study_set:) }
  let(:test_step) { create(:test_step, test:, term: correct_term, exercise: :pick_term) }

  before do
    ([correct_term] + other_terms).each do |term|
      term.term_audio.attach(io: StringIO.new('mp3'), filename: "#{term.id}.mp3", content_type: 'audio/mpeg')
    end
    other_terms.each { |term| create(:test_step, test:, term:, exercise: :pick_term) }
  end

  it 'renders audio buttons for answer terms with attached audio' do
    rendered = render_inline(described_class.new(test_step:))

    expect(rendered.css('[data-controller="audio-player"]').count).to eq(4)
  end

  def user
    @user ||= create(:user)
  end

  def study_set
    @study_set ||= create(:study_set, user:)
  end
end
