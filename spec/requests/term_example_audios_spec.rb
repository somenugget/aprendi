RSpec.describe 'Term example audios' do
  let(:user) { create(:user) }
  let(:study_set) { create(:study_set, user: user) }
  let(:term) { create(:term, study_set: study_set) }
  let(:term_example) { create(:term_example, terms: [term]) }
  let(:other_term_example) do
    other_user = create(:user)
    other_study_set = create(:study_set, user: other_user)
    other_term = create(:term, study_set: other_study_set)

    create(:term_example, terms: [other_term])
  end

  before do
    sign_in user
  end

  it 'redirects to attached audio for an owned term example' do
    term_example.term_example_audio.attach(io: StringIO.new('mp3'), filename: 'example.mp3', content_type: 'audio/mpeg')

    get term_example_audio_path(term_example)

    expect(response).to have_http_status(:redirect)
  end

  it 'returns not found when audio is missing' do
    get term_example_audio_path(term_example)

    expect(response).to have_http_status(:not_found)
  end

  it 'returns not found for another user term example' do
    other_term_example.term_example_audio.attach(io: StringIO.new('mp3'), filename: 'example.mp3',
                                                 content_type: 'audio/mpeg')

    get term_example_audio_path(other_term_example)

    expect(response).to have_http_status(:not_found)
  end
end
