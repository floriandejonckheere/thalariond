# Redirect $stdout and $stderr to a logger
class IOLogger < Logger
  alias puts info
  alias write info
  def flush; self; end
end

interactive = (Rails.env.test? or
                !!defined?(Rails::Console) or
                !!defined?(Rails::Generators))

if !interactive and !ENV.has_key?('LDAPD_DISABLE')
  require Rails.root.join 'lib', 'ldapd.rb'

  LDAPd.pid = Process.fork

  if LDAPd.pid
    Rails.logger.info "Starting thalariond with PID #{Process.pid}"
    Rails.logger.info "Starting up LDAPd with PID #{LDAPd.pid}"

    Thread.new do
      Process.waitpid LDAPd.pid

      Rails.logger.info "LDAPd exited with status #{$?.exitstatus}"

      Kernel.exit!
    end
  else
    # Set up logging
    log_file = Rails.root.join 'log', "ldapd.#{Rails.env}.log"

    logger = IOLogger.new log_file
    logger.level = Rails.logger.level || Logger::DEBUG

    logger.info "Starting up LDAPd with PID #{Process.pid}"

    $stdout = logger
    $stderr = logger

    $server = LDAPd::Server.new :logger => logger

    def exit_server
      $server.stop

      Kernel.exit!
    end

    # Stop server on parent exit
    trap('TERM') { exit_server }

    begin
      $server.start
    rescue => e
      logger.error e.message
      e.backtrace.each { |er| logger.error er }

      exit_server
    end
  end
end
