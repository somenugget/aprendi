class CreateStreakLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :streak_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.date :activity_date

      t.timestamps
    end
  end
end
