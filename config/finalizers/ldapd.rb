include ApplicationHelper

if server? and LDAPd.pid
  Rails.logger.info "Stopping LDAPd with PID #{LDAPd.pid}"
  Process.kill 'KILL', LDAPd.pid # raises Errno::ESRCH
end
