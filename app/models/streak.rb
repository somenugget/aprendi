class Streak < ApplicationRecord
  belongs_to :user

  attribute :current_streak, :integer, default: 0
  attribute :longest_streak, :integer, default: 0
end
