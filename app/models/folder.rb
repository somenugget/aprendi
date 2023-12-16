class Folder < ApplicationRecord
  belongs_to :user

  has_one :study_config, as: :configurable, dependent: :destroy

  has_many :study_sets, dependent: :destroy
  has_many :terms, dependent: :destroy, through: :study_sets
  has_many :own_terms, -> { where(study_set_id: nil) }, class_name: 'Term', dependent: :destroy, inverse_of: :folder

  validates :name, presence: true
end
