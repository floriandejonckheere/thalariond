class CreateJoinTableGroupService < ActiveRecord::Migration
  def change
    create_join_table :groups, :services do |t|
      # t.index [:group_id, :service_id]
      # t.index [:service_id, :group_id]
    end
  end
end
