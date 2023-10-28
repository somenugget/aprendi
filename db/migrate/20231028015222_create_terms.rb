class CreateTerms < ActiveRecord::Migration[7.1]
  def change
    create_table :terms do |t|
      t.references :folder, null: false, foreign_key: true
      t.references :study_set, null: false, foreign_key: true
      t.string :term, null: false
      t.string :definition, null: false

      t.timestamps
    end
  end
end
