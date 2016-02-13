# Use puts instead of possibly non-initialized Rails.logger
puts "Stopping LDAPd"

if $pid
  Process.kill 'INT', $pid
  Process.wait $pid
end
