class StudySet < ApplicationRecord
  belongs_to :user
  belongs_to :folder

  has_one :study_config, as: :configurable, dependent: :destroy

  has_many :terms, dependent: :destroy
  has_many :tests, dependent: :destroy

  validates :name, presence: true
end
