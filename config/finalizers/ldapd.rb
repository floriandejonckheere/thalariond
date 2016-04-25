require 'ldapd'

unless Rails.env.test? or !!defined?(Rails::Console)
  if LDAPd.pid
    Process.kill 'TERM', LDAPd.pid
  end
end
