class CreateUserSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :user_settings do |t|
      t.references :user
      t.string :tz
      t.string :term_lang
      t.string :definition_lang
      t.boolean :daily_reminder, default: false
      t.boolean :weekly_reminder, default: false
      t.timestamps
    end
  end
end
