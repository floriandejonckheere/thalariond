require 'ldap/server'

class LDAPServer::Server
  def start
    opts = { :port => Rails.application.config.ldap['port'],
              :namingContexts => Rails.application.config.ldap['base_dn'],
              :operation_class => LDAPServer::Operation}

    if Rails.application.config.ldap.has_key?(:ssl_cert)
      opts[:ssl_cert_file] = Rails.application.config.ldap['ssl_cert']
      opts[:ssl_key_file] = Rails.application.config.ldap['ssl_key']
    end

    server = LDAP::Server.new(opts)

    at_exit do
      puts '=> Stopping LDAP server'
      server.stop
    end

    server.run_tcpserver
    server.join
  end
end
