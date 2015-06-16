require 'ldap/server/util'

module LDAPServer
  class DN

    def self.split(dn)
      attrs = Hash.new
      split_dn = LDAP::Server::Operation.split_dn(dn)
      split_dn.each do |d|
        # There should be only one key
        d.each { |key, value| attrs[key.to_sym] = value }
      end
      return attrs
    end

  end
end
