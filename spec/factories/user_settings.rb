FactoryBot.define do
  factory :user_settings do
    user
    daily_reminder { true }
    tz { 'Europe/Warsaw' }
  end
end
