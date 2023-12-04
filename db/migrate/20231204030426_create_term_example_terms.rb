class CreateTermExampleTerms < ActiveRecord::Migration[7.1]
  def change
    create_table :term_example_terms do |t|
      t.references :term_example, null: false, foreign_key: true
      t.references :term, null: false, foreign_key: true

      t.timestamps
    end
  end
end
