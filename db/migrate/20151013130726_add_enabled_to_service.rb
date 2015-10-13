class AddEnabledToService < ActiveRecord::Migration
  def change
    add_column :services, :enabled, :boolean, default: true
  end
end
