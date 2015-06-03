class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string  :name,                null: false
      t.string  :display_name
      t.integer :owner

      t.timestamps null: false
    end
  end
end
