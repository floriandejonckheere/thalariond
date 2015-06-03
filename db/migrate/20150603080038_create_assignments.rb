class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :user
      t.references :role
      t.timestamps null: false
    end
    add_index :assignments, [:user_id, :role_id], :unique => true
  end
end
