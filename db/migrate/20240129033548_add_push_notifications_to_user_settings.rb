class AddPushNotificationsToUserSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :user_settings, :push_notifications, :boolean, default: false, null: false
  end
end
