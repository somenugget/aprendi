class AccountDeletionRequest < ApplicationRecord
  belongs_to :user

  enum :status, { pending: 0, confirmed: 1, complete: 2 }
end
