class CreateDomainAliases < ActiveRecord::Migration
  def change
    create_table :domain_aliases do |t|
      t.text :alias,                    null: false
      t.text :domain, index: true,      null: false

      t.timestamps null: false
    end

    add_index :domain_aliases, :alias,            unique: true
  end
end
