require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'uid_valid' do
    assert_nil u('dummy')
    props = {
      :uid => 'dummy',
      :email => 'dummy@example.com',
      :first_name => 'Dummy',
      :password => 'abcd1234',
      :password_confirmation => 'abcd1234'
    }

    # Must contain at least three characters
    props[:uid] = 'a'; assert_raise(ActiveRecord::RecordInvalid) { User.create! props }
    props[:uid] = 'ab'; assert_raise(ActiveRecord::RecordInvalid) { User.create! props }

    # Must only contain alphanumeric characters and _-
    props[:uid] = 'abc%'; assert_raise(ActiveRecord::RecordInvalid) { User.create! props }
    props[:uid] = 'abc$'; assert_raise(ActiveRecord::RecordInvalid) { User.create! props }
    props[:uid] = 'abc"'; assert_raise(ActiveRecord::RecordInvalid) { User.create! props }
    props[:uid] = "abc'"; assert_raise(ActiveRecord::RecordInvalid) { User.create! props }
  end

  test 'owned_groups_included_in_groups' do
    assert_not_nil g('user1-user2@example.com')
    assert_equal u('user2'), g('user1-user2@example.com').owner

    assert u('user2').groups.include? g('user1-user2@example.com')
    assert u('user2').owned_groups.include? g('user1-user2@example.com')

    assert u('user1').groups.include? g('user1-user2@example.com')
    assert_not u('user1').owned_groups.include? g('user1-user2@example.com')
  end

  test 'uid_immutable' do
    assert_raise do
      u('user1').update :uid => 'user99'
    end
  end

  test 'sanitize_attributes' do
    assert_nil u('dummy')
    assert User.create!(:uid => 'DUMMY',
                        :email => 'DUMMY@DUMMY.COM',
                        :first_name => 'Dummy',
                        :password => 'abcd1234',
                        :password_confirmation => 'abcd1234')

    assert u('dummy')
    assert_equal 'dummy@dummy.com', u('dummy').email
  end

  test 'unique_user_service_name' do
    assert u('user1')
    assert_nil s('user1')
    assert_raise ActiveRecord::RecordInvalid do
      Service.create!(:uid => 'user1', :display_name => 'User 1')
    end
  end

  test 'email_outside_managed_domain' do
    assert d('example.com')

    assert_raises ActiveRecord::RecordInvalid do
      User.create!(:uid => 'dummy',
                    :email => 'dummy@example.com',
                    :first_name => 'Dummy',
                    :password => 'abcd1234',
                    :password_confirmation => 'abcd1234')
    end
  end
end
