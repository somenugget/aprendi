class CreateStudyConfigs < ActiveRecord::Migration[7.1]
  def change
    create_table :study_configs do |t|
      t.references :configurable, polymorphic: true, null: false
      t.string :term_lang
      t.string :definition_lang

      t.timestamps
    end
  end
end
