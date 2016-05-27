class AddIndexOnAuthEventUser < ActiveRecord::Migration
  def change
    add_index :auth_events, :user_id
  end
end
