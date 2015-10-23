class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :priority,            null: false, default: 0
      t.text :title,                  null: false
      t.text :text,                   null: false
      t.boolean :read,                null: false, default: false
      t.references :user
      t.datetime :timestamp,          null: false

      t.timestamps null: false
    end
  end
end
