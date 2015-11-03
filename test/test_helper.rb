ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'database_cleaner'

DatabaseCleaner.start

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def u(uid)
    User.find_by(:uid => uid)
  end

  def a(uid)
    Ability.new u(uid)
  end

  def s(uid)
    Service.find_by(:uid => uid)
  end

  def g(name)
    Group.find_by(:name => name)
  end

  def e(email)
    Email.find_by(:mail => email.split('@').first, :domain => Domain.find_by(:domain => email.split('@').last))
  end

  def ea(email_alias)
    EmailAlias.find_by(:alias => email_alias)
  end

  def d(domain)
    Domain.find_by(:domain => domain)
  end

  def da(domain_alias)
    DomainAlias.find_by(:alias => domain_alias)
  end
end
