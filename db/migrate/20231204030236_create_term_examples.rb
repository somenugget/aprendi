class CreateTermExamples < ActiveRecord::Migration[7.1]
  def change
    create_table :term_examples do |t|
      t.string :term, null: false
      t.string :definition, null: false
      t.string :term_lang, null: false
      t.string :definition_lang, null: false
      t.string :term_example, null: false
      t.string :definition_example, null: false

      t.timestamps

      t.index :term
      t.index :definition
      t.index :term_lang
      t.index :definition_lang
    end
  end
end
