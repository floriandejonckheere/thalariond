include ApplicationHelper

if server?
  Rails.logger.info "Stopping LDAPd with PID #{LDAPd.pid}"

  if LDAPd.pid
    begin
      Process.kill 'KILL', LDAPd.pid
    rescue Errno::ESRCH
      Rails.logger.error "LDAPd with PID #{LDAPd.pid} already reaped"
    end
  end
end
