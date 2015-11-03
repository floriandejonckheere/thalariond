class AddOrderToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :order, :integer
  end
end
