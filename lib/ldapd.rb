require 'ldap/server'
require 'ldap/server/router'

require 'multi_logger'
require 'logger'

require 'ldapd/ldap_controller'
require 'ldapd/connection'

module LDAPd
class Server
  @server
  @logger

  def initialize
    log_file = File.open(File.join(Rails.root, 'log', "ldapd.#{Rails.env}.log"), 'a')
    @logger = Logger.new MultiLogger.new(STDOUT, log_file)
    if ENV['RAILS_ENV'] == 'development'
      @logger.level = Logger::DEBUG
    else
      @logger.level = Logger::WARN
    end
  end

  def self.logger
    @logger
  end

  def start
    config = Rails.application.config.ldap

    router = LDAP::Server::Router.new(@logger) do
      bind    'uid=:uid, ou=Users, dc=thalarion, dc=be' => 'LDAPController#bindUser'
      bind    'uid=:uid, ou=Services, dc=thalarion, dc=be' => 'LDAPController#bindService'
      bind    'mail=:mail, dc=:domain, ou=Mail, dc=thalarion, dc=be' => 'LDAPController#bindMail'
      bind    'uid=:uid, cn=:group, ou=Groups, dc=thalarion, dc=be' => 'LDAPController#bindGroup'

      search  'ou=Users, dc=thalarion, dc=be' => 'LDAPController#searchUser'
      search  'ou=Groups, dc=thalarion, dc=be' => 'LDAPController#searchGroup'
      search  'ou=Services, dc=thalarion, dc=be' => 'LDAPController#searchService'
      search  'ou=Mail, dc=thalarion, dc=be' => 'LDAPController#searchDomain'
      search  'dc=:domain, ou=Mail, dc=thalarion, dc=be' => 'LDAPController#searchMail'
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

    @logger.info "Starting LDAPd"
    @server.run_tcpserver
    @server.join
  end

  def stop
    @logger.info "Stopping LDAPd"
    @logger.close
    @server.stop
  end
end
end
