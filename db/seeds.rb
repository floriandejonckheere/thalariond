# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', city: cities.first)

administrator = Role.create!(:name => 'administrator',
                              :display_name => 'System administrator')
Role.create!(:name => 'master',
              :display_name => 'Master')
Role.create!(:name => 'operator',
              :display_name => 'Operator')
Role.create!(:name => 'user',
              :display_name => 'User')
Role.create!(:name => 'service',
              :display_name => 'Service')
Role.create!(:name => 'mail',
              :display_name => 'Mail')

admin = User.create!(:uid => 'admin',
                      :email => 'admin@example.com',
                      :first_name => 'Administrator',
                      :password => 'abcd1234')

admin.roles << administrator
