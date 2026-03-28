class StudySet < ApplicationRecord
  belongs_to :user
  belongs_to :folder, optional: true

  has_one :study_config, as: :configurable, dependent: :destroy

  has_many :terms, dependent: :destroy

  validates :name, presence: true
  validate :folder_belongs_to_user, if: -> { folder_id.present? }

  private

  def folder_belongs_to_user
    return if user&.folders&.exists?(folder_id)

    errors.add(:folder_id, :invalid)
  end
end
