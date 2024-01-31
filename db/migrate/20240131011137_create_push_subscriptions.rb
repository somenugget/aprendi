class CreatePushSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :push_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :user_agent, null: false
      t.string :endpoint, null: false
      t.string :p256dh, null: false
      t.string :auth, null: false
      t.timestamp :last_seen_at, null: false
      t.timestamps

      t.index [:user_agent, :user_id], name: 'index_user_agent_user_id', unique: true
      t.index [:endpoint, :user_id], name: 'index_endpoint_user_id', unique: true
    end
  end
end
