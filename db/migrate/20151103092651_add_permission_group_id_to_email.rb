class AddPermissionGroupIdToEmail < ActiveRecord::Migration
  def change
    add_reference :emails, :group, index: true, foreign_key: true
  end
end
