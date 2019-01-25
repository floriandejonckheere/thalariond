# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', city: cities.first)

Rails.logger.info 'Loading seed data'

administrator = Role.find_or_initialize_by(:name => 'administrator')
administrator.display_name = 'System Administrator'
administrator.order = 4
administrator.save!

master = Role.find_or_initialize_by(:name => 'master')
master.display_name = 'Master'
master.order = 3
master.save!

operator = Role.find_or_initialize_by(:name => 'operator')
operator.display_name = 'Operator'
operator.order = 2
operator.save!

user = Role.find_or_initialize_by(:name => 'user')
user.display_name = 'User'
user.order = 1
user.save!

service = Role.find_or_initialize_by(:name => 'service')
service.display_name = 'Service'
service.save!

mail = Role.find_or_initialize_by(:name => 'mail')
mail.display_name = 'Mail'
mail.save!
