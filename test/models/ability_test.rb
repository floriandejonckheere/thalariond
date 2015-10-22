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
    assert s('service3-mail').can? :read, g('user3@example.com')

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
    assert s('service3-mail').can? :read, u('user3')
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
    assert u('user3-mail').can? :read, u('user3')

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

  test 'mail' do
    assert u('user1-mail').can? :list, Domain
    assert s('service1-mail').can? :list, Domain
    Domain.all.each do |domain|
      assert u('user1-mail').can? :read, domain
      assert s('service1-mail').can? :read, domain
    end

    assert u('user1-mail').can? :list, DomainAlias
    assert s('service1-mail').can? :list, DomainAlias
    DomainAlias.all.each do |domain_alias|
      assert u('user1-mail').can? :read, domain_alias
      assert s('service1-mail').can? :read, domain_alias
    end
  end

  test 'mail_user' do
    assert u('user1-mail').can? :read, e('user1@example.com')
    assert u('user1-mail').can? :read, e('user1-2@example.com')
    assert u('user1-mail').cannot? :read, e('user3@example.com')
    assert u('user2-mail').cannot? :read, e('user1@example.com')
    assert u('user2-mail').can? :read, e('user1-2@example.com')
    assert u('user2-mail').cannot? :read, e('user3@example.com')
    assert u('user3-mail').cannot? :read, e('user1@example.com')
    assert u('user3-mail').cannot? :read, e('user1-2@example.com')
    assert u('user3-mail').can? :read, e('user3@example.com')
  end

  test 'mail_service' do
    assert s('service1-mail').can? :read, e('user1@example.com')
    assert s('service1-mail').can? :read, e('user1-2@example.com')
    assert s('service1-mail').cannot? :read, e('user3@example.com')
    assert s('service2-mail').cannot? :read, e('user1@example.com')
    assert s('service2-mail').can? :read, e('user1-2@example.com')
    assert s('service2-mail').cannot? :read, e('user3@example.com')
    assert s('service3-mail').cannot? :read, e('user1@example.com')
    assert s('service3-mail').cannot? :read, e('user1-2@example.com')
    assert s('service3-mail').can? :read, e('user3@example.com')
  end

end
