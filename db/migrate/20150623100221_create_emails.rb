class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.text :mail
      t.belongs_to :domain

      t.timestamps null: false
    end
  end
end
