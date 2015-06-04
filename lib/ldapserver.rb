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

    # (uid=foo) => [:eq, "uid", matchobj, "foo"]
    def search(basedn, scope, deref, filter)
      raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" unless basedn.end_with?(Rails.application.config.ldap['base_dn'])

    end

  end

end
