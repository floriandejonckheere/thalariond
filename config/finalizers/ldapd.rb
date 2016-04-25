require 'ldapd'

if LDAPd.pid
  Process.kill 'TERM', LDAPd.pid
end
