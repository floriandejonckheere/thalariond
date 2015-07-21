require 'test_helper'

class GroupTest < ActiveSupport::TestCase

  john_com_group = Group.find_by(name: 'john@example.com')
  john = User.find_by!(uid: 'john')

  test 'group_john_ownership' do
    assert john_com_group.owner == john
    assert john_com_group.users.include? john
  end

  test 'group_owner_ownership' do
    group = Group.create!(:name => 'UserGroup')
    assert_raise do
      john.owned_groups << group
    end
  end

end
