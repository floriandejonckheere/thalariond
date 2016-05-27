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

  test 'smaller_than' do
    assert_nil r('user') < r('mail')
    assert_not r('user') < r('user')
    assert r('user') < r('operator')
    assert r('user') < r('master')
    assert r('user') < r('administrator')

    assert_nil r('operator') < r('mail')
    assert_not r('operator') < r('user')
    assert_not r('operator') < r('operator')
    assert r('operator') < r('master')
    assert r('operator') < r('administrator')

    assert_nil r('master') < r('mail')
    assert_not r('master') < r('user')
    assert_not r('master') < r('operator')
    assert_not r('master') < r('master')
    assert r('master') < r('administrator')

    assert_nil r('administrator') < r('mail')
    assert_not r('administrator') < r('user')
    assert_not r('administrator') < r('operator')
    assert_not r('administrator') < r('master')
    assert_not r('administrator') < r('administrator')

    assert_nil r('mail') < r('mail')
    assert_nil r('mail') < r('user')
    assert_nil r('mail') < r('operator')
    assert_nil r('mail') < r('master')
    assert_nil r('mail') < r('administrator')
  end

  test 'greater_than' do
    assert_nil r('user') > r('mail')
    assert_not r('user') > r('user')
    assert_not r('user') > r('operator')
    assert_not r('user') > r('master')
    assert_not r('user') > r('administrator')

    assert_nil r('operator') > r('mail')
    assert r('operator') > r('user')
    assert_not r('operator') > r('operator')
    assert_not r('operator') > r('master')
    assert_not r('operator') > r('administrator')

    assert_nil r('master') > r('mail')
    assert r('master') > r('user')
    assert r('master') > r('operator')
    assert_not r('master') > r('master')
    assert_not r('master') > r('administrator')

    assert_nil r('administrator') > r('mail')
    assert r('administrator') > r('user')
    assert r('administrator') > r('operator')
    assert r('administrator') > r('master')
    assert_not r('administrator') > r('administrator')

    assert_nil r('mail') > r('mail')
    assert_nil r('mail') > r('user')
    assert_nil r('mail') > r('operator')
    assert_nil r('mail') > r('master')
    assert_nil r('mail') > r('administrator')
  end

  test 'smaller_than_or_equal' do
    assert_nil r('user') <= r('mail')
    assert r('user') <= r('user')
    assert r('user') <= r('operator')
    assert r('user') <= r('master')
    assert r('user') <= r('administrator')

    assert_nil r('operator') <= r('mail')
    assert_not r('operator') <= r('user')
    assert r('operator') <= r('operator')
    assert r('operator') <= r('master')
    assert r('operator') <= r('administrator')

    assert_nil r('master') <= r('mail')
    assert_not r('master') <= r('user')
    assert_not r('master') <= r('operator')
    assert r('master') <= r('master')
    assert r('master') <= r('administrator')

    assert_nil r('administrator') <= r('mail')
    assert_not r('administrator') <= r('user')
    assert_not r('administrator') <= r('operator')
    assert_not r('administrator') <= r('master')
    assert r('administrator') <= r('administrator')

    assert_nil r('mail') <= r('mail')
    assert_nil r('mail') <= r('user')
    assert_nil r('mail') <= r('operator')
    assert_nil r('mail') <= r('master')
    assert_nil r('mail') <= r('administrator')
  end

  test 'greater_than_or_equal' do
    assert_nil r('user') >= r('mail')
    assert r('user') >= r('user')
    assert_not r('user') >= r('operator')
    assert_not r('user') >= r('master')
    assert_not r('user') >= r('administrator')

    assert_nil r('operator') >= r('mail')
    assert r('operator') >= r('user')
    assert r('operator') >= r('operator')
    assert_not r('operator') >= r('master')
    assert_not r('operator') >= r('administrator')

    assert_nil r('master') >= r('mail')
    assert r('master') >= r('user')
    assert r('master') >= r('operator')
    assert r('master') >= r('master')
    assert_not r('master') >= r('administrator')

    assert_nil r('administrator') >= r('mail')
    assert r('administrator') >= r('user')
    assert r('administrator') >= r('operator')
    assert r('administrator') >= r('master')
    assert r('administrator') >= r('administrator')

    assert_nil r('mail') >= r('mail')
    assert_nil r('mail') >= r('user')
    assert_nil r('mail') >= r('operator')
    assert_nil r('mail') >= r('master')
    assert_nil r('mail') >= r('administrator')
  end

  test 'equal_to' do
    assert_nil r('user') == r('mail')
    assert r('user') == r('user')
    assert_not r('user') == r('operator')
    assert_not r('user') == r('master')
    assert_not r('user') == r('administrator')

    assert_nil r('operator') == r('mail')
    assert_not r('operator') == r('user')
    assert r('operator') == r('operator')
    assert_not r('operator') == r('master')
    assert_not r('operator') == r('administrator')

    assert_nil r('master') == r('mail')
    assert_not r('master') == r('user')
    assert_not r('master') == r('operator')
    assert r('master') == r('master')
    assert_not r('master') == r('administrator')

    assert_nil r('administrator') == r('mail')
    assert_not r('administrator') == r('user')
    assert_not r('administrator') == r('operator')
    assert_not r('administrator') == r('master')
    assert r('administrator') == r('administrator')

    assert_nil r('mail') == r('mail')
    assert_nil r('mail') == r('user')
    assert_nil r('mail') == r('operator')
    assert_nil r('mail') == r('master')
    assert_nil r('mail') == r('administrator')
  end

  test 'not_equal_to' do
    assert_nil r('user') != r('mail')
    assert_not r('user') != r('user')
    assert r('user') != r('operator')
    assert r('user') != r('master')
    assert r('user') != r('administrator')

    assert_nil r('operator') != r('mail')
    assert r('operator') != r('user')
    assert_not r('operator') != r('operator')
    assert r('operator') != r('master')
    assert r('operator') != r('administrator')

    assert_nil r('master') != r('mail')
    assert r('master') != r('user')
    assert r('master') != r('operator')
    assert_not r('master') != r('master')
    assert r('master') != r('administrator')

    assert_nil r('administrator') != r('mail')
    assert r('administrator') != r('user')
    assert r('administrator') != r('operator')
    assert r('administrator') != r('master')
    assert_not r('administrator') != r('administrator')

    assert_nil r('mail') != r('mail')
    assert_nil r('mail') != r('user')
    assert_nil r('mail') != r('operator')
    assert_nil r('mail') != r('master')
    assert_nil r('mail') != r('administrator')
  end

  test 'spaceship' do
    assert_equal nil, r('user') <=> r('mail')
    assert_equal 0, r('user') <=> r('user')
    assert_equal -1, r('user') <=> r('operator')
    assert_equal -1, r('user') <=> r('master')
    assert_equal -1, r('user') <=> r('administrator')

    assert_equal nil, r('operator') <=> r('mail')
    assert_equal 1, r('operator') <=> r('user')
    assert_equal 0, r('operator') <=> r('operator')
    assert_equal -1, r('operator') <=> r('master')
    assert_equal -1, r('operator') <=> r('administrator')

    assert_equal nil, r('master') <=> r('mail')
    assert_equal 1, r('master') <=> r('user')
    assert_equal 1, r('master') <=> r('operator')
    assert_equal 0, r('master') <=> r('master')
    assert_equal -1, r('master') <=> r('administrator')

    assert_equal nil, r('administrator') <=> r('mail')
    assert_equal 1, r('administrator') <=> r('user')
    assert_equal 1, r('administrator') <=> r('operator')
    assert_equal 1, r('administrator') <=> r('master')
    assert_equal 0, r('administrator') <=> r('administrator')

    assert_equal nil, r('mail') <=> r('mail')
    assert_equal nil, r('mail') <=> r('user')
    assert_equal nil, r('mail') <=> r('operator')
    assert_equal nil, r('mail') <=> r('master')
    assert_equal nil, r('mail') <=> r('administrator')
  end
end
