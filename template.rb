begin
  User.all.reject { |u| u.uid == 'admin' }.each { |u| u.destroy }
  Service.all.destroy_all
  Group.all.destroy_all
  Domain.all.destroy_all
  DomainAlias.all.destroy_all
  Email.all.destroy_all
  EmailAlias.all.destroy_all
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
postfix = Service.create!(:uid => 'postfix',
                      :display_name => 'Postfix MTA',
                      :password => 'abcd1234')
postfix.roles << Role.find_by(name: 'service')
postfix.roles << Role.find_by(name: 'mail')

dovecot = Service.create!(:uid => 'dovecot',
                      :display_name => 'Dovecot',
                      :password => 'abcd1234')
dovecot.roles << Role.find_by(name: 'service')
dovecot.roles << Role.find_by(name: 'mail')

thalariond = Service.create!(:uid => 'thalariond',
                              :display_name => 'Thalarion System',
                              :password => 'abcd1234')

# Groups
thalarion_group = Group.new(:name => 'thalarion@thalarion.be',
                  :display_name => 'Email account for thalarion@thalarion.be')
thalarion_group.save!

postfix.groups << thalarion_group
thalariond.groups << thalarion_group

# Domains
domain = Domain.create!(:domain => 'thalarion.be')
Email.create!(:mail => 'thalarion', :domain => domain)
