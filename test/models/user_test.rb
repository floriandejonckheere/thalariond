require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'sanitize_attributes' do
    assert_nil u('dummy')
    assert User.create!(:uid => 'DUMMY',
                        :email => 'DUMMY@DUMMY',
                        :first_name => 'Dummy',
                        :password => 'abcd1234',
                        :password_confirmation => 'abcd1234')

    assert u('dummy')
    assert_equal 'dummy@dummy', u('dummy').email
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
