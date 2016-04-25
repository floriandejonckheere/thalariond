require 'ldapd'

begin
  Process.kill 'TERM', LDAPd.pid if LDAPd.pid
rescue Errno::ESRCH
end
