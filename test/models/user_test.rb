require 'test_helper'

# Run the following command before each test-run
# $ bundle exec rake db:reset RAILS_ENV=test

class UserTest < ActiveSupport::TestCase

  john = User.find_by!(uid: 'john')
  jane = User.find_by!(uid: 'jane')
  jake = User.find_by!(uid: 'jake')

  test 'group_user_memberships' do
    john_com_group = Group.find_by!(name: 'john@example.com')
    assert john_com_group.owner == john
    assert john_com_group.users.include? john
    assert john_com_group.users.include? jane
    assert (not john_com_group.users.include? jake)
  end

  test 'email_outside_managed_domains' do
    assert_raise ActiveRecord::RecordInvalid do
      User.create!(:uid => 'john-clone',
                    :first_name => 'John',
                    :email => 'john@example.com')
    end
  end

  test 'group_ownership_included' do
    group = Group.create!(:name => 'UserGroup')
    assert_raise do
      john.owned_groups << group
    end
  end

end
