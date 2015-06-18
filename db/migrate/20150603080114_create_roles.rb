class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name,                null: false
      t.string :display_name

      t.timestamps null: false
    end
  end
end
