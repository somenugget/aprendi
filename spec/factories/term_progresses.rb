FactoryBot.define do
  factory :term_progress do
    term { nil }
    user { nil }
    learnt { false }
    tests_count { 1 }
    success_percentage { 1 }
    next_test_date { '2023-10-27 20:59:52' }
  end
end
