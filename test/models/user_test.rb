require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'memberships' do
    john = User.find_by!(uid: 'john')
    ability = Ability.new(john)
    #~ group = Group.find_by(name: "john.jane@mydomain.com")
    assert ability.can? :read, User
  end

end
