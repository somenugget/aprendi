class CreateUserAuthTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :user_auth_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token_hash
      t.timestamp :expires_at

      t.timestamps
    end
  end
end
