#!/usr/bin/env ruby

require 'erb'

ENV['RAILS_ENV'] ||= 'development'

# Load Rails environment
root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)
require File.join(root, 'config', 'environment')

ActiveRecord::Base.establish_connection(YAML::load(ERB.new(File.read(File.join(root, 'config', 'database.yml'))).result)[ENV['RAILS_ENV']])

# Load ldapd
require File.join(root, 'lib', 'ldapd')
include LDAPd

server = LDAPd::Server.new

Signal.trap('TERM') do
  server.stop
end

server.start
