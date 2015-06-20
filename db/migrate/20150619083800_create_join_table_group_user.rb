class CreateJoinTableGroupUser < ActiveRecord::Migration
  def change
    create_join_table :groups, :users do |t|
      t.index [:group_id, :user_id], :unique => true
    end
  end
end