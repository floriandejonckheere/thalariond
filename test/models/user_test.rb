require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'unique_user_service_name' do
    assert u('user1')
    assert_nil s('user1')
    assert_raise ActiveRecord::RecordInvalid do
      Service.create!(:uid => 'user1', :display_name => 'User 1')
    end
  end
end
