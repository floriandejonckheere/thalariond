require 'test_helper'

class RoleTest < ActiveSupport::TestCase

  test 'role_assignment' do
    assert u('user1').has_role? :user
    assert_not u('user1').has_role? :operator
    assert_not u('user1').has_role? :master
    assert_not u('user1').has_role? :administrator

    assert u('admin').has_role? :user
    assert u('admin').has_role? :operator
    assert u('admin').has_role? :master
    assert u('admin').has_role? :administrator
  end

  test 'assign_lower' do
    u('user1').roles << r('master')
    assert u('user1').has_role? :user
    assert u('user1').has_role? :operator
    assert u('user1').has_role? :master
    assert_not u('user1').has_role? :administrator

    u('user1').roles << r('administrator')
    assert u('user1').has_role? :user
    assert u('user1').has_role? :operator
    assert u('user1').has_role? :master
    assert u('user1').has_role? :administrator
  end

  test 'unassign_higher' do
    u('master').roles.delete r('master')
    assert u('master').has_role? :user
    assert u('master').has_role? :operator
    assert_not u('master').has_role? :master
    assert_not u('master').has_role? :administrator

    u('master').roles.delete r('operator')
    assert u('master').has_role? :user
    assert_not u('master').has_role? :operator
    assert_not u('master').has_role? :master
    assert_not u('master').has_role? :administrator

    u('admin').roles.delete r('operator')
    assert u('admin').has_role? :user
    assert_not u('admin').has_role? :operator
    assert_not u('admin').has_role? :master
    assert_not u('admin').has_role? :administrator
  end

end
