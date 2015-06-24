class CreateJoinTableServiceRole < ActiveRecord::Migration
  def change
    create_join_table :services, :roles do |t|
      t.index [:service_id, :role_id], :unique => true
    end
  end
end
