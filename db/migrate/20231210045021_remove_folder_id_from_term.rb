class RemoveFolderIdFromTerm < ActiveRecord::Migration[7.1]
  def change
    remove_column :terms, :folder_id, :bigint
  end
end
