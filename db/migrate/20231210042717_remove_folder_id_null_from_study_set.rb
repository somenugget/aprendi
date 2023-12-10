class RemoveFolderIdNullFromStudySet < ActiveRecord::Migration[7.1]
  def change
    change_column_null :study_sets, :folder_id, true
  end
end
