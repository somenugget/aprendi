class AddMetaToUserAuthToken < ActiveRecord::Migration[7.1]
  def change
    add_column :user_auth_tokens, :meta, :jsonb, default: {}
  end
end
