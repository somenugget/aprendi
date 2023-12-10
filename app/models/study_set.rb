class StudySet < ApplicationRecord
  belongs_to :user
  belongs_to :folder, optional: true

  has_one :study_config, as: :configurable, dependent: :destroy

  has_many :terms, dependent: :destroy

  validates :name, presence: true
end
