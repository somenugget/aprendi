class CreateTermProgresses < ActiveRecord::Migration[7.1]
  def change
    create_table :term_progresses do |t|
      t.references :term, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :learnt, default: false
      t.integer :tests_count, default: 0
      t.integer :success_percentage
      t.datetime :next_test_date

      t.timestamps
    end
  end
end
