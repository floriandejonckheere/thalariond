require 'test_helper'

# If this test suite fails, please check that there are no
# instances of ldapd running, even when the PID file says otherwise.
class LDAPdTest < ActiveSupport::TestCase
  $ldapd = Rails.root.join 'bin', 'ldapd'
  $pid_file = Rails.root.join('tmp', 'pids', 'ldapd.pid')

  def setup
    begin
      `#{$ldapd} stop`
      File.delete $pid_file
    rescue; end
  end

  test 'help' do
    `#{$ldapd} help`
    assert_equal 0, $?.exitstatus
  end

  test 'status' do
    begin
      File.delete $pid_file
    rescue; end

    `#{$ldapd} status`
    assert_equal 1, $?.exitstatus

    # write bogus pid that exists
    File.open($pid_file, 'w') { |f| f.write 1 }

    `#{$ldapd} status`
    assert_equal 0, $?.exitstatus

    File.delete $pid_file
  end

  test 'start stop' do
    # ldapd not running
    `#{$ldapd} stop`
    assert_equal 1, $?.exitstatus

    # start ldapd successfully
    `#{$ldapd} start`
    assert_equal 0, $?.exitstatus

    # ldapd already started
    `#{$ldapd} start`
    assert_equal 1, $?.exitstatus

    # stop ldapd successfully
    `#{$ldapd} stop`
    assert_equal 0, $?.exitstatus

    # ldapd already stopped
    `#{$ldapd} stop`
    assert_equal 1, $?.exitstatus
  end
end
