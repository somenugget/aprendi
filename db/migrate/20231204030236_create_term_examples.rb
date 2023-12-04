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
    end
  end
end
