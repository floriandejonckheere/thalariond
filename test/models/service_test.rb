require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  test 'unique_service_user_name' do
    assert s('service1')
    assert_nil u('service1')
    assert_raise ActiveRecord::RecordInvalid do
      User.create!(:uid => 'service1', :first_name => 'Service 1')
    end
  end
end
