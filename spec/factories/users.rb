FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    sequence(:first_name) { |n| "PersonName#{n}" }
    sequence(:last_name) { |n| "PersonLastName#{n}" }
    password { 'password12345' }
    timezone { 'America/New_York' }
    confirmed_at { 1.year.ago }
  end
end
