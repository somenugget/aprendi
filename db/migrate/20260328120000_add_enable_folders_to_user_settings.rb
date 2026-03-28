# frozen_string_literal: true

class AddEnableFoldersToUserSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :user_settings, :enable_folders, :boolean, default: false, null: false
  end
end
