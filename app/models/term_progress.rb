class TermProgress < ApplicationRecord
  belongs_to :user
  belongs_to :term

  attribute :tests_count, :integer, default: 0
  attribute :success_percentage, :integer, default: 0
end
