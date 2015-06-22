# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', city: cities.first)

administrator = Role.create!(:name => 'administrator',
                              :display_name => 'System administrator')
Role.create!(:name => 'operator',
              :display_name => 'Operator')
Role.create!(:name => 'user',
              :display_name => 'User')

admin = User.create!(:uid => 'admin',
                      :email => 'admin@example.com',
                      :first_name => 'Administrator',
                      :password => 'abcd1234')

thalariond = Service.create!(:uid => 'thalariond',
                              :display_name => 'Thalarion System',
                              :password => 'abcd1234')

group = Group.create!(:name => 'thalarion@thalarion.be',
                      :display_name => 'Email for thalarion@thalarion.be')

thalariond.groups << group

admin.roles << administrator
