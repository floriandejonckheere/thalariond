interactive = (Rails.env.test? or
                !!defined?(Rails::Console) or
                !!defined?(Rails::Generators) or
                !!defined?(::Rake))

unless interactive and ENV['LDAPD_DISABLE']
  require Rails.root.join('lib', 'ldapd.rb')

  log_file = Rails.root.join('log', "ldapd.#{Rails.env}.log")

  LDAPd.pid = Process.fork

  if LDAPd.pid
    Process.detach LDAPd.pid
    # Start watcher thread
  else
    # Set up logging
    logger = Logger.new(log_file)
    logger.level = Rails.logger.level || Logger::DEBUG

    $stdout.reopen(log_file, 'a')
    $stderr.reopen(log_file, 'a')

    $server = LDAPd::Server.new :logger => logger

    trap 'TERM' do
      $server.stop
    end

    restart_count = 0

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

        # Server ran for less than 10s
        if ((end_time - start_time) * 24 * 60 * 60) < 10
          logger.error "LDAPd ran for less than 10 seconds, aborting"
          Process.kill 'TERM', Process.ppid

          # Prevent running finalizers
          Kernel.exit!
        end
      end
    end
  end
end
