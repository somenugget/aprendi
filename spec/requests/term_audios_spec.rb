RSpec.describe 'Term audios' do
  let(:user) { create(:user) }
  let(:study_set) { create(:study_set, user:) }
  let(:term) { create(:term, study_set:) }
  let(:other_term) do
    other_user = create(:user)
    other_study_set = create(:study_set, user: other_user)
    create(:term, study_set: other_study_set)
  end

  before do
    sign_in user
  end

  it 'redirects to attached audio for an owned term' do
    term.term_audio.attach(io: StringIO.new('mp3'), filename: 'term.mp3', content_type: 'audio/mpeg')

    get term_audio_path(term)

    expect(response).to have_http_status(:redirect)
  end

  it 'returns not found when audio is missing' do
    get term_audio_path(term)

    expect(response).to have_http_status(:not_found)
  end

  it 'returns not found for another user term' do
    other_term.term_audio.attach(io: StringIO.new('mp3'), filename: 'term.mp3', content_type: 'audio/mpeg')

    get term_audio_path(other_term)

    expect(response).to have_http_status(:not_found)
  end
end
