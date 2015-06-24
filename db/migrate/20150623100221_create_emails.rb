class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.text :mail,                   null: false
      t.belongs_to :domain,           null: false

      t.timestamps null: false
    end

    add_index :emails, [:mail, :domain_id],                unique: true
  end
end
