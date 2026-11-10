RSpec.describe ReminderMailer do
  describe '#daily' do
    let(:user) { create(:user) }

    before do
      allow(described_class).to receive(:default_url_options).and_return(host: 'example.com')
    end

    it 'links to the dashboard through a unique login token' do
      create(:term, study_set: create(:study_set, user: user))

      mail = described_class.daily(user)
      document = Nokogiri::HTML(mail.body.encoded)
      link = URI.parse(document.at_css('a')['href'])
      token = Rack::Utils.parse_query(link.query)['token']
      auth_token = UserAuthToken.find_by_token(token)

      expect(link.path).to eq(dashboard_path)
      expect(auth_token.user).to eq(user)
      expect(auth_token.meta['purpose']).to eq('reminder_login')
      expect(auth_token.expires_at).to be_within(5.seconds).of(1.day.from_now)
    end

    it 'does not create a token when there are no terms to learn' do
      expect { described_class.daily(user).deliver_now }.not_to change(UserAuthToken, :count)
    end
  end
end
