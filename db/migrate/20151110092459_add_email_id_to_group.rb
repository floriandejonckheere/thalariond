class AddEmailIdToGroup < ActiveRecord::Migration
  def change
    add_reference :groups, :email, index: true
  end
end
