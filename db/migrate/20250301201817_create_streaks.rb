class CreateStreaks < ActiveRecord::Migration[7.2]
  def change
    create_table :streaks do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :current_streak
      t.integer :longest_streak
      t.date :last_activity_date

      t.timestamps
    end
  end
end
