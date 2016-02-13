# Use puts instead of possibly non-initialized Rails.logger
Rails.logger.info "Stopping LDAPd with PID #{LDAPd.pid}"

if LDAPd.pid
  begin
    Process.kill 'INT', LDAPd.pid
    Process.wait LDAPd.pid
  rescue Errno::ESRCH
    Rails.logger.warn "LDAPd with PID #{LDAPd.pid} already reaped"
  end
end
