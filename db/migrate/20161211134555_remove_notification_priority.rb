class RemoveNotificationPriority < ActiveRecord::Migration[5.0]
  def change
    remove_column :notifications, :priority
  end
end
