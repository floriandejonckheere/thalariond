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

    @opts[:pid_file] ||= File.join(Rails.root, 'tmp', 'pids', 'ldapd.pid')

    ActiveRecord::Base.establish_connection(YAML::load(ERB.new(File.read(File.join(Rails.root, 'config', 'database.yml'))).result)[@opts[:environment]])

    if @opts[:logger]
      @logger = @opts[:logger]
    else
      @logger = Logger.new(@opts[:log_file] || STDOUT)
      @logger.level = @opts[:log_level] || Logger::DEBUG
    end
  end

  def daemonize
    Process.daemon
    start
  end

  def start
    config = Rails.application.config.ldap

    @logger.info "Starting LDAPd in #{Rails.env} on #{config['bindaddr']}:#{config['port']}"

    File.open(@opts[:pid_file], 'w') { |f| f.write Process.pid }

    router = LDAP::Server::Router.new(@logger) do
      bind    'uid=:uid, ou=Users, dc=thalarion, dc=be' => 'LDAPd::LDAPController#bindUser'
      bind    'uid=:uid, ou=Services, dc=thalarion, dc=be' => 'LDAPd::LDAPController#bindService'
      bind    'mail=:mail, dc=:domain, ou=Mail, dc=thalarion, dc=be' => 'LDAPd::LDAPController#bindMail'
      bind    'uid=:uid, cn=:group, ou=Groups, dc=thalarion, dc=be' => 'LDAPd::LDAPController#bindGroup'

      search  'ou=Users, dc=thalarion, dc=be' => 'LDAPd::LDAPController#searchUser'
      search  'ou=Groups, dc=thalarion, dc=be' => 'LDAPd::LDAPController#searchGroup'
      search  'cn=:group, ou=Groups, dc=thalarion, dc=be' => 'LDAPd::LDAPController#searchMember'
      search  'ou=Services, dc=thalarion, dc=be' => 'LDAPd::LDAPController#searchService'
      search  'ou=Mail, dc=thalarion, dc=be' => 'LDAPd::LDAPController#searchDomain'
      search  'dc=:domain, ou=Mail, dc=thalarion, dc=be' => 'LDAPd::LDAPController#searchMail'
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
