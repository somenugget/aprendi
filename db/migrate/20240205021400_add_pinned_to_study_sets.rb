class AddPinnedToStudySets < ActiveRecord::Migration[7.1]
  def change
    add_column :study_sets, :pinned, :boolean, default: false
  end
end
