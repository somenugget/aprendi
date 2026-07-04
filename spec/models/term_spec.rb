RSpec.describe Term do
  it 'has one attached term audio' do
    expect(described_class.reflect_on_attachment(:term_audio).macro).to eq(:has_one_attached)
  end
end
