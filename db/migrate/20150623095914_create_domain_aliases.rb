class CreateDomainAliases < ActiveRecord::Migration
  def change
    create_table :domain_aliases do |t|
      t.text :alias
      t.text :domain, index: true

      t.timestamps null: false
    end

    add_index :domain_aliases, :alias,            unique: true
  end
end
