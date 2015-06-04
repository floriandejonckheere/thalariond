require 'ldap/server'

module LDAPServer

  def start
    opts = { :port => Rails.application.config.ldap['port'],
              :namingContexts => Rails.application.config.ldap['base_dn'],
              :operation_class => LDAPOperation}

    if Rails.application.config.ldap.has_key?(:ssl_cert)
      opts[:ssl_cert_file] = Rails.application.config.ldap['ssl_cert']
      opts[:ssl_key_file] = Rails.application.config.ldap['ssl_key']
    end

    server = LDAP::Server.new(opts)

    server.run_tcpserver
    server.join
  end

  class LDAPOperation < LDAP::Server::Operation

    def search(basedn, scope, deref, filter)
      basedn.downcase!

      puts LDAP::Server::Operation.anonymous?

      raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" unless basedn.end_with?(Rails.application.config.ldap['base_dn'])

      puts "Search: basedn=#{basedn.inspect}, scope=#{scope.inspect}, deref=#{deref.inspect}, filter=#{filter.inspect}\n"

      raise LDAP::ResultError::InvalidSyntax, "Invalid search filter" unless filter[0]

    end

    def simple_bind(version, dn, password)
      if dn == nil || !(dn.end_with?(Rails.application.config.ldap['base_dn']))
        raise LDAP::ResultError::InappropriateAuthentication
      end
      puts self.split_dn
    end

  end

end
