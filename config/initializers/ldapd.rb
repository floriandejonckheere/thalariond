unless Rails.env.test? or !!defined?(Rails::Console)
  require Rails.root.join('lib', 'ldapd.rb')

  LOG_FILE = Rails.root.join('log', "ldapd.#{Rails.env}.log")
  MIN_RUNTIME = 10

  LDAPd.pid = Process.fork

  if LDAPd.pid
    Process.detach LDAPd.pid
    # Start watcher thread
  else
    # Set up logging
    logger = Logger.new(LOG_FILE)
    logger.level = Rails.logger.level || Logger::DEBUG

    $stdout.reopen(LOG_FILE, 'a')
    $stderr.reopen(LOG_FILE, 'a')

    $server = LDAPd::Server.new :logger => logger

    trap 'TERM' do
      $server.stop
    end

    loop do
      logger.info 'Starting LDAPd'

      begin
        start_time = DateTime.now
        $server.start
      rescue
        next
      ensure
        # gets called after rescue, but before next
        end_time = DateTime.now
        logger.warn "LDAPd stopped, ran for #{((end_time - start_time) * 24 * 60 * 60).to_i} seconds"
      end

      # Server ran for less than 10s
      if ((end_time - start_time) * 24 * 60 * 60) < MIN_RUNTIME
        logger.error "LDAPd ran for less than #{MIN_RUNTIME} seconds, aborting"
        Process.kill 'TERM', Process.ppid

        # Prevent running finalizers
        Kernel.exit!
      end
    end
  end
end
