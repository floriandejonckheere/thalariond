class CreateAuthEvents < ActiveRecord::Migration
  def change
    create_table :auth_events do |t|
      t.text :component,              null: false
      t.text :action,                 null: false
      t.boolean :result,              null: false
      t.text :ip
      t.text :agent
      t.references :user
      t.datetime :timestamp,          null: false

      t.timestamps null: false
    end
  end
end
