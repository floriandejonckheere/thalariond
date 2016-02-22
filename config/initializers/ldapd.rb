unless ENV['RAILS_ENV'].nil? or ENV['RAILS_ENV'] == 'test'
  require Rails.root.join('lib', 'ldapd.rb')

  Rails.logger.info "Starting LDAPd"

  LDAPd.pid = Process.fork

  if LDAPd.pid
    Rails.logger.info "LDAPd running with PID #{LDAPd.pid}"

    # Start watcher thread
    Thread.new(LDAPd.pid) do |pid|
      Process.wait pid
      LDAPd.exit_status = $?.exitstatus
      LDAPd.pid = nil
      Rails.logger.error "LDAPd failed with status #{LDAPd.exit_status}"
    end
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
