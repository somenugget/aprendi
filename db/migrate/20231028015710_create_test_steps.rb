class CreateTestSteps < ActiveRecord::Migration[7.1]
  def change
    create_table :test_steps do |t|
      t.references :test, null: false, foreign_key: true
      t.references :term, null: false, foreign_key: true
      t.integer :status, default: 0
      t.integer :exercise, null: false
      t.integer :position

      t.timestamps
    end
  end
end
