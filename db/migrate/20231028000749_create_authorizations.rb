class CreateAuthorizations < ActiveRecord::Migration[7.1]
  def change
    create_table :authorizations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :token
      t.string :refresh_token

      t.timestamps
    end

    add_index :authorizations, %i[provider uid], unique: true
  end
end
