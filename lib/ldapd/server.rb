require 'erb'

require 'ldap/server'
require 'ldap/server/router'

require 'ldapd/ldap_controller'
require 'ldapd/connection'

module LDAPd
class Server
  def initialize(opts)
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

    params = { :bindaddr => ENV['LDAPD_BINDADDR'],
                :port => ENV['LDAPD_PORT'],
                :router => router,
                :namingContexts => ENV['LDAPD_BASEDN'],
                :logger => opts[:logger]
    }

    if ENV['LDAPD_SSL_CERT']
      params[:ssl_cert_file] = ENV['LDAPD_SSL_CERT']
      params[:ssl_key_file] = ENV['LDAPD_SSL_KEY']
      params[:ssl_ca_path] = ENV['LDAPD_SSL_CA_PATH'] if ENV['LDAPD_SSL_CA_PATH']
      params[:ssl_dhparams] = ENV['LDAPD_SSL_DHPARAMS'] if ENV['LDAPD_SSL_DHPARAMS']
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
