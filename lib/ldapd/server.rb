require 'erb'

require 'ldap/server'
require 'ldap/server/router'

require 'ldapd/ldap_controller'
require 'ldapd/connection'

module LDAPd
class Server
  def initialize(opts)
    config = YAML::load(ERB.new(File.read(Rails.root.join 'config', 'ldapd.yml')).result)

    ActiveRecord::Base.establish_connection(YAML::load(ERB.new(File.read(Rails.root.join('config', 'database.yml'))).result)[Rails.env])

    opts[:logger].info "Initializing LDAPd in #{Rails.env} mode on #{config['bindaddr']}:#{config['port']}"

    router = LDAP::Server::Router.new(opts[:logger]) do
      # Common authentication methods
      bind    'uid=:uid, ou=services, dc=thalarion, dc=be' => 'LDAPd::LDAPController#bindService'
      # Dovecot authentication methods
      bind    'mail=:mail, dc=:domain, ou=mail, dc=thalarion, dc=be' => 'LDAPd::LDAPController#bindMail'
      # GitLab authentication methods
      bind    'uid=:uid, cn=:group, ou=groups, dc=thalarion, dc=be' => 'LDAPd::LDAPController#bindGroup'

      # Dovecot search methods
      search  'ou=mail, dc=thalarion, dc=be' => 'LDAPd::LDAPController#searchDomains'
      search  'dc=:domain, ou=mail, dc=thalarion, dc=be' => 'LDAPd::LDAPController#searchDomain'
      # GitLab search methods
      search  'cn=:group, ou=groups, dc=thalarion, dc=be' => 'LDAPd::LDAPController#searchGroup'
    end

    params = { :bindaddr => config['bindaddr'],
                :port => config['port'],
                :router => router,
                :namingContexts => config['base_dn'],
                :logger => opts[:logger]
    }

    if config['ssl_cert']
      params[:ssl_cert_file] = config['ssl_cert']
      params[:ssl_key_file] = config['ssl_key']
      params[:ssl_ca_path] = config['ssl_ca_path'] if config['ssl_ca_path']
      params[:ssl_dhparams] = config['ssl_dhparams'] if config['ssl_ca_dhparams']
    end

    @server = LDAP::Server.new params
  end

  def start
    @server.run_tcpserver
    @server.join
  end

  def stop
    @server.stop
  end
end
end
