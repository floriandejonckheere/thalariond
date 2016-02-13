include ApplicationHelper

if server?
  require Rails.root.join('lib', 'ldapd.rb')

  Rails.logger.info "Starting LDAPd"

  LDAPd.pid = Process.fork

  if LDAPd.pid
    puts "LDAPd running with PID #{LDAPd.pid}" if LDAPd.pid

    # Reap child process
    Process.detach LDAPd.pid
  else
    $server = LDAPd::Server.new(
      :log_file => Rails.root.join('log', "ldapd.#{Rails.env}.log"),
      :log_level => Rails.logger.level
    )

    $server.start

    # Prevent running finalizers
    Kernel.exit!
  end
end
