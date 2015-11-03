class AddEmailIdToGroup < ActiveRecord::Migration
  def change
    add_reference :groups, :email, index: true, foreign_key: true
  end
end
