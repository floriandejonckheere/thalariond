require 'ldap/server'
require 'logger'

require_relative 'ldapserver/operation'

module LDAPServer

  class Server
    @server
    @logger

    def initialize(root)
      @logger = Logger.new(File.join(root, 'log', "ldapd.#{Rails.env}.log"))
    end

    def self.logger
      @logger
    end

    def start
      config = Rails.application.config.ldap

      opts = { :bindaddr => config['bindaddr'],
                :port => config['port'],
                :namingContexts => config['base_dn'],
                :operation_class => LDAPServer::Operation,
                :logger => @logger
      }

      if config.has_key?(:ssl_cert)
        opts[:ssl_cert_file] = config[:ssl_cert]
        opts[:ssl_key_file] = config[:ssl_key]
        opts[:ssl_ca_path] = config[:ssl_ca_path] if config.has_key?(:ssl_ca_path)
        opts[:ssl_dhparams] = config[:ssl_dhparams] if config.has_key?(:ssl_dhparams)
      end

      @server = LDAP::Server.new(opts)

      @logger.info "Starting LDAP server"
      @server.run_tcpserver
      @server.join
    end

    def stop
      @logger.info "Stopping LDAP server"
      @server.stop
    end
  end
end
