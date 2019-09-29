# frozen_string_literal: true

class AddRightsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :rights, :string, array: true, null: false, default: []
  end
end
