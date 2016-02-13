# Use puts instead of possibly non-initialized Rails.logger
puts "Starting LDAPd"

$pid = Process.fork

puts "LDAPd running with PID #{$pid}" if $pid

unless $pid
  require Rails.root.join('lib', 'ldapd.rb')

  $server = LDAPd::Server.new(
    :log_file => Rails.root.join('log', "ldapd.#{Rails.env}.log"),
    :log_level => Rails.logger.level
  )

  $server.start

  # Prevent running finalizers
  Kernel.exit!
end
