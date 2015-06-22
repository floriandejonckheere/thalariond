begin
  User.find_by(uid: 'florian').destroy
  User.find_by(uid: 'john').destroy
  Service.find_by(uid: 'postfix').destroy
  Group.find_by(name: 'info@thalarion.be').destroy
rescue NoMethodError
end

# Users
florian = User.new(:uid => 'florian',
                  :first_name => 'Florian',
                  :last_name => 'Dejonckheere',
                  :email => 'florian@floriandejonckheere.be',
                  :password => 'abcd1234')

florian.save!
florian.roles << Role.find_by(name: 'administrator')

john = User.new(:uid => 'john',
                  :first_name => 'John',
                  :last_name => 'Doe',
                  :email => 'john.doe@example.com',
                  :password => 'abcd1234')
john.save!
john.roles << Role.find_by(name: 'user')

# Services
postfix = Service.new(:uid => 'postfix',
                      :display_name => 'Postfix MTA',
                      :password => 'abcd1234')

# Groups
group = Group.new(:name => 'info@thalarion.be',
                  :display_name => 'Email account for info@thalarion.be')
group.save!

florian.groups << group
florian.owned_groups << group
john.groups << group
postfix.groups << group
