require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'base' do
    assert u('user1').can? :list, Service
    assert s('service1').can? :list, Service
    Service.all.each do |service|
      assert u('user1').can? :read, service
      assert s('service1').can? :read, service
    end

    assert u('user1').can? :list, Role
    assert s('service1').can? :list, Role
    Role.all.each do |role|
      assert u('user1').can? :read, role
      assert s('service1').can? :read, role
    end
  end

  test 'service' do
    # Groups
    assert s('service1').can? :read, g('user1@example.com')
    assert s('service1').can? :read, g('user1-2@example.com')
    assert s('service1').cannot? :read, g('user3@example.com')
    assert s('service2').cannot? :read, g('user1@example.com')
    assert s('service2').can? :read, g('user1-2@example.com')
    assert s('service2').cannot? :read, g('user3@example.com')
    assert s('service3').cannot? :read, g('user1@example.com')
    assert s('service3').cannot? :read, g('user1-2@example.com')
    assert s('service3').can? :read, g('user3@example.com')
    assert s('service3-mail').cannot? :read, g('user1@example.com')
    assert s('service3-mail').cannot? :read, g('user1-2@example.com')
    assert s('service3-mail').cannot? :read, g('user3@example.com')

    # Users
    assert s('service1').can? :read, u('user1')
    assert s('service1').can? :read, u('user2')
    assert s('service1').cannot? :read, u('user3')
    assert s('service2').can? :read, u('user1')
    assert s('service2').can? :read, u('user2')
    assert s('service2').cannot? :read, u('user3')
    assert s('service3').cannot? :read, u('user1')
    assert s('service3').cannot? :read, u('user2')
    assert s('service3').can? :read, u('user3')
    assert s('service3-mail').cannot? :read, u('user1')
    assert s('service3-mail').cannot? :read, u('user2')
    assert s('service3-mail').cannot? :read, u('user3')
  end

  test 'user' do
    # Self
    assert u('user1').can? :read, u('user1')
    assert u('user1').can? :update, u('user1')
    assert u('user1').cannot? :update, u('user3')

    # Groups
    assert u('user1').can? :read, g('user1@example.com')
    assert u('user1').can? :read, g('user1-2@example.com')
    assert u('user1').cannot? :read, g('user3@example.com')
    assert u('user2').cannot? :read, g('user1@example.com')
    assert u('user2').can? :read, g('user1-2@example.com')
    assert u('user2').cannot? :read, g('user3@example.com')
    assert u('user3').cannot? :read, g('user1@example.com')
    assert u('user3').cannot? :read, g('user1-2@example.com')
    assert u('user3').can? :read, g('user3@example.com')

    # Users
    assert u('user1').can? :read, u('user1')
    assert u('user1').can? :read, u('user2')
    assert u('user1').cannot? :read, u('user3')
    assert u('user2').can? :read, u('user1')
    assert u('user2').can? :read, u('user2')
    assert u('user2').cannot? :read, u('user3')
    assert u('user3').cannot? :read, u('user1')
    assert u('user3').cannot? :read, u('user2')
    assert u('user3').can? :read, u('user3')
    assert u('user3-mail').cannot? :read, u('user1')
    assert u('user3-mail').cannot? :read, u('user2')
    assert u('user3-mail').cannot? :read, u('user3')

    # Group ownership
    assert u('user1').can? :update, g('user1@example.com')
    assert u('user1').cannot? :update, g('user1-2@example.com')
    assert u('user1').cannot? :update, g('user3@example.com')
    assert u('user2').cannot? :update, g('user1@example.com')
    assert u('user2').can? :update, g('user1-2@example.com')
    assert u('user2').cannot? :update, g('user3@example.com')
    assert u('user3').cannot? :update, g('user1@example.com')
    assert u('user3').cannot? :update, g('user1-2@example.com')
    assert u('user3').can? :update, g('user3@example.com')
    assert u('user3-mail').cannot? :update, g('user1@example.com')
    assert u('user3-mail').cannot? :update, g('user1-2@example.com')
    assert u('user3-mail').cannot? :update, g('user3@example.com')
  end

end
