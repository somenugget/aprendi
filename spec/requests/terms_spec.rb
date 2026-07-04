RSpec.describe 'Terms' do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }
  let(:study_set) { create(:study_set, user:) }
  let(:term) { create(:term, study_set:, term: 'hola', definition: 'hello') }

  before do
    ActiveJob::Base.queue_adapter = :test
    clear_enqueued_jobs
    sign_in user
  end

  after do
    clear_enqueued_jobs
  end

  it 'enqueues audio generation when a term is created' do
    expect do
      post study_set_terms_path(study_set), params: { term: { term: 'hola', definition: 'hello' } }
    end.to have_enqueued_job(GenerateTermAudioJob)
  end

  it 'enqueues audio regeneration when term text changes' do
    expect do
      update_term(text: 'adios', definition: 'bye')
    end.to have_enqueued_job(GenerateTermAudioJob).with(term.id)
  end

  it 'purges stale audio when term text changes' do
    term.term_audio.attach(io: StringIO.new('old'), filename: 'old.mp3', content_type: 'audio/mpeg')

    update_term(text: 'adios', definition: 'bye')

    expect(term.reload.term_audio).not_to be_attached
  end

  it 'does not enqueue audio regeneration when only definition changes' do
    expect do
      update_term(text: 'hola', definition: 'hi')
    end.not_to have_enqueued_job(GenerateTermAudioJob)
  end

  def update_term(text:, definition:)
    patch study_set_term_path(study_set, term), params: { term: { term: text, definition: definition } }
  end
end
