class TermProgress < ApplicationRecord
  belongs_to :user
  belongs_to :term

  attribute :tests_count, :integer, default: 0
  attribute :success_percentage, :integer, default: 0

  scope :for_term, ->(term) { where(term: term) }
  scope :for_user, ->(user) { where(user: user) }

  PERCENTAGE_THRESHOLD = {
    good: 85,
    medium: 60,
    bad: 0
  }.freeze
end
