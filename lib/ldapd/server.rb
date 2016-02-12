require 'erb'

require 'ldap/server'
require 'ldap/server/router'

require 'logger'

require 'ldapd/ldap_controller'
require 'ldapd/connection'

module LDAPd
class Server
  attr_reader :server, :logger, :opts

  def initialize(opts)
    @opts = opts
    @opts[:environment] = ENV['RAILS_ENV'] || 'development'

    @opts[:pid_file] ||= Rails.root.join('tmp', 'pids', 'ldapd.pid')

    ActiveRecord::Base.establish_connection(YAML::load(ERB.new(File.read(Rails.root.join('config', 'database.yml'))).result)[@opts[:environment]])

    # Be aware that STDOUT is null-routed when daemonizing
    if @opts[:logger]
      @logger = @opts[:logger]
    else
      @logger = Logger.new(@opts[:log_file] || STDOUT)
      @logger.level = @opts[:log_level] || Logger::DEBUG
    end
  end

  def start(daemonize = :foreground)
    Process.daemon if daemonize == :background

    config = Rails.application.config.ldap

    @logger.info "Starting LDAPd in #{Rails.env} on #{config['bindaddr']}:#{config['port']}"

    File.open(@opts[:pid_file], 'w') { |f| f.write Process.pid }

    router = LDAP::Server::Router.new(@logger) do
      # Common authentication methods
      bind    'uid=:uid, ou=services, dc=thalarion, dc=be' => 'LDAPd::LDAPController#bindService'
      # Dovecot authentication methods
      bind    'mail=:mail, dc=:domain, ou=mail, dc=thalarion, dc=be' => 'LDAPd::LDAPController#bindMail'
      # GitLab authentication methods
      bind    'uid=:uid, cn=:group, ou=groups, dc=thalarion, dc=be' => 'LDAPd::LDAPController#bindGroup'

      # Common search methods
      search  'cn=:group, ou=groups, dc=thalarion, dc=be' => 'LDAPd::LDAPController#searchGroup'
      # Dovecot search methods
      search  'ou=mail, dc=thalarion, dc=be' => 'LDAPd::LDAPController#searchDomain'
      search  'dc=:domain, ou=mail, dc=thalarion, dc=be' => 'LDAPd::LDAPController#searchMail'
      # GitLab search methods
      search  'uid=:uid, cn=:group, ou=groups, dc=thalarion, dc=be' => 'LDAPd::LDAPController#searchMember'
    end

    opts = { :bindaddr => config['bindaddr'],
              :port => config['port'],
              :router => router,
              :namingContexts => config['base_dn'],
              :logger => @logger
    }

    if config.has_key?(:ssl_cert)
      opts[:ssl_cert_file] = config[:ssl_cert]
      opts[:ssl_key_file] = config[:ssl_key]
      opts[:ssl_ca_path] = config[:ssl_ca_path] if config.has_key?(:ssl_ca_path)
      opts[:ssl_dhparams] = config[:ssl_dhparams] if config.has_key?(:ssl_dhparams)
    end

    @server = LDAP::Server.new(opts)
    @server.run_tcpserver
    @server.join

    @logger.info "Stopping LDAPd"
    @logger.close
    File.delete @opts[:pid_file]
    @server.stop
  end
end
end
