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

  def s(uid)
    Service.find_by(:uid => uid)
  end

  def g(name)
    Group.find_by(:name => name)
  end

  def m(mail, domain)
    Mail.find_by(:mail => mail, :domain.domain => domain)
  end

  def ma(mail_alias)
    MailAlias.find_by(:alias => mail_alias)
  end

  def d(domain)
    Domain.find_by(:domain => domain)
  end

  def da(domain_alias)
    DomainAlias.find_by(:alias => domain_alias)
  end
end
