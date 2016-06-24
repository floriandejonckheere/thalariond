require 'test_helper'

class EmailAliasTest < ActiveSupport::TestCase
  test 'validate_no_emails' do
    assert_raise ActiveRecord::RecordInvalid do
      EmailAlias.create! :alias => 'user1@example.com', :mail => 'test@domain.tld'
    end
  end
end
