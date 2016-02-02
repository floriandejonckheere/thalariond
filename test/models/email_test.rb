require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  test 'email_fixtures_have_permission_groups' do
    Email.all.each do |email|
      assert email.group
    end
  end

  test 'new_email_has_permission_group' do
    assert_nil g('dummy@example.com')
    assert Email.create!(:mail => 'dummy', :domain => Domain.find_by(:domain => 'example.com'))
    assert g('dummy@example.com')
  end

  test 'email_destroy_permission_group' do
    assert e('user1@example.com')
    assert g('user1@example.com')
    assert e('user1@example.com').destroy!
    assert_nil g('user1@example.com')
  end
end
