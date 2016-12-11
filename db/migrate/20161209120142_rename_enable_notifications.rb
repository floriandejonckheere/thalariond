class RenameEnableNotifications < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :enable_notifications, :notifications_enabled
  end
end
