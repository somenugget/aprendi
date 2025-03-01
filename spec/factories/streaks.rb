FactoryBot.define do
  factory :streak do
    user { nil }
    current_streak { 1 }
    longest_streak { 1 }
    last_activity_date { '2025-03-01' }
  end
end
