class CreateJoinTableGroupService < ActiveRecord::Migration
  def change
    create_join_table :groups, :services do |t|
      t.index [:group_id, :service_id], :unique => true
    end
  end
end
