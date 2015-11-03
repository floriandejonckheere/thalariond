require 'test_helper'

class RoleTest < ActiveSupport::TestCase

  test 'test_role_chaining' do
    user = User.find_by(uid: 'user1')
    assert user.has_role? :user
    assert_not user.has_role? :operator
    assert_not user.has_role? :master
    assert_not user.has_role? :administrator

    ## Test assign_lower
    user.roles << Role.find_by(name: 'master')
    assert user.has_role? :user
    assert user.has_role? :operator
    assert user.has_role? :master
    assert_not user.has_role? :administrator

    user.roles << Role.find_by(name: 'administrator')
    assert user.has_role? :user
    assert user.has_role? :operator
    assert user.has_role? :master
    assert user.has_role? :administrator

    ## Test unassign_higher
    user.roles.delete Role.find_by(name: 'master')
    assert user.has_role? :user
    assert user.has_role? :operator
    assert_not user.has_role? :master
    assert_not user.has_role? :administrator

    user.roles.delete Role.find_by(name: 'operator')
    assert user.has_role? :user
    assert_not user.has_role? :operator
    assert_not user.has_role? :master
    assert_not user.has_role? :administrator
  end

end
