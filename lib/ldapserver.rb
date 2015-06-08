#!/usr/bin/env ruby
ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
RAILS_ROOT = "#{File.dirname(__FILE__)}/../" unless defined?(RAILS_ROOT)

require 'rubygems'
require 'active_record'
require File.expand_path(File.join(RAILS_ROOT, 'config', 'environment'))

ActiveRecord::Base.establish_connection(YAML::load(File.open(File.join('config', 'database.yml')))[ENV['RAILS_ENV']])

module LDAPServer
end

require 'ldapserver/operation'
require 'ldapserver/server'

server = LDAPServer::Server.new
server.start
