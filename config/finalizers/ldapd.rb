unless ENV['RAILS_ENV'].nil? or ENV['RAILS_ENV'] == 'test'
  if LDAPd.pid
    Rails.logger.info "Stopping LDAPd with PID #{LDAPd.pid}"
    Process.kill 'KILL', LDAPd.pid # raises Errno::ESRCH
  end
end
