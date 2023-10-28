class Test < ApplicationRecord
  belongs_to :study_set
  belongs_to :user

  has_many :test_steps, dependent: :destroy
  has_many :terms, through: :test_steps
end
