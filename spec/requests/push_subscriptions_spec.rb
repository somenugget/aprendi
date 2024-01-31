require 'rails_helper'

RSpec.describe 'PushNotifications' do
  describe 'POST /push_subscriptions' do
    before do
      sign_in create(:user)
    end

    it 'returns http success' do
      post '/push_subscriptions', params: { push_subscription: { endpoint: 'https://example.com', p256dh: 'p256dh', auth: 'auth', user_agent: 'user_agent' } }

      expect(response).to have_http_status(:success)
    end
  end
end
