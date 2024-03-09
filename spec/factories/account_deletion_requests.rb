FactoryBot.define do
  factory :account_deletion_request do
    user
    status { 'pending' }
  end
end
