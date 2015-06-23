class CreateEmailAliases < ActiveRecord::Migration
  def change
    create_table :email_aliases do |t|
      t.text :alias
      t.text :mail

      t.timestamps null: false
    end

    add_index :email_aliases, :alias,               unique: true
  end
end
