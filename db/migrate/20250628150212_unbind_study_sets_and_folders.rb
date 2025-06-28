class UnbindStudySetsAndFolders < ActiveRecord::Migration[7.2]
  def up
    ActiveRecord::Base.connection.execute("UPDATE study_sets SET folder_id = NULL WHERE folder_id IS NOT NULL")
  end

  def down; end
end
