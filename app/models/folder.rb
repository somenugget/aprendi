class Folder < ApplicationRecord
  belongs_to :user

  has_one :study_config, as: :configurable, dependent: :destroy

  has_many :study_sets, dependent: :destroy
  has_many :terms, dependent: :destroy, through: :study_sets

  validates :name, presence: true
end
