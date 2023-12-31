FactoryBot.define do
  factory :study_set do
    study_config { association :study_config, strategy: :build, configurable: instance }
    user { nil }
    folder { nil }
    name { 'MyString' }
  end
end
