FactoryBot.define do
  factory :push_subscription do
    user
    endpoint { 'https://example.com' }
    p256dh { 'p256dh' }
    auth { 'auth' }
    user_agent { 'user_agent' }
    last_used_at { Time.zone.now }
  end
end
