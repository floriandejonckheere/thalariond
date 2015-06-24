class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.text :domain,                   null: false

      t.timestamps null: false
    end

    add_index :domains, :domain,            unique: true
  end
end
