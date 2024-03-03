FactoryBot.define do
  factory :user_auth_token do
    user { nil }
    token_hash { 'MyString' }
    expires_at { '2024-03-02 22:50:34' }
  end
end
