class RemoveNullConstraintOnUserAuthTokenUserId < ActiveRecord::Migration[7.1]
  def change
    change_column_null :user_auth_tokens, :user_id, true
  end
end
