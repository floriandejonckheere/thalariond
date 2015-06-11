require 'ldap/server'

require_relative 'ldapserver/operation'

module LDAPServer

  class Server
    @server

    def start
      opts = { :port => Rails.application.config.ldap['port'],
                :namingContexts => Rails.application.config.ldap['base_dn'],
                :operation_class => LDAPServer::Operation}

      if Rails.application.config.ldap.has_key?(:ssl_cert)
        opts[:ssl_cert_file] = Rails.application.config.ldap['ssl_cert']
        opts[:ssl_key_file] = Rails.application.config.ldap['ssl_key']
      end

      @server = LDAP::Server.new(opts)

      puts '=> Starting LDAP server'
      @server.run_tcpserver
      @server.join
    end

    def stop
      puts '=> Stopping LDAP server'
      @server.stop
    end
  end
end
