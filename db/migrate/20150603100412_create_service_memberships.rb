class CreateServiceMemberships < ActiveRecord::Migration
  def change
    create_table :service_memberships do |t|
      t.references :service
      t.references :group
      t.timestamps null: false
    end
    add_index :service_memberships, [:service_id, :group_id], :unique => true
  end
end
