ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'database_cleaner'

Rails.logger = Logger.new STDOUT

DatabaseCleaner.strategy = :truncation, { :except => %w[roles] }

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  setup :setup_database
  teardown :teardown_database

  def setup_database
    DatabaseCleaner.start
  end

  def teardown_database
    DatabaseCleaner.clean
  end

  # Add more helper methods to be used by all tests here...
  def r(name)
    Role.find_by(:name => name)
  end

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
    split = email.split('@')
    Email.find_by(:mail => split.first, :domain => Domain.find_by(:domain => split.last))
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
