# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', city: cities.first)

administrator = Role.create!(:name => 'administrator',
                              :display_name => 'System administrator',
                              :order => 4)
Role.create!(:name => 'master',
              :display_name => 'Master',
              :order => 3)
Role.create!(:name => 'operator',
              :display_name => 'Operator',
              :order => 2)
Role.create!(:name => 'user',
              :display_name => 'User',
              :order => 1)
Role.create!(:name => 'service',
              :display_name => 'Service')
Role.create!(:name => 'mail',
              :display_name => 'Mail')
