require 'ldap/server/util'

module LDAPServer
  class DN
    @dname

    def initialize(dn)
      @dname = LDAP::Server::Operation.split_dn(dn)
    end

    def find_one(attr)
      @dname.each do |pair|
        return pair[attr.to_s] if pair[attr.to_s]
      end
      return nil
    end

    def find(attr)
      result = []
      @dname.each do |pair|
        result << pair[attr.to_s] if pair[attr.to_s]
      end
      return nil if result.empty?
      return result
    end

    def starts_with?(dn)
      needle = LDAP::Server::Operation.split_dn(dn)

      # Needle is longer than haystack
      return false if needle.length > @dname.length

      needle_index = 0
      haystack_index = 0

      while needle_index < needle.length
        return false if @dname[haystack_index] != needle[needle_index]
        needle_index += 1
        haystack_index += 1
      end
      return true
    end

    def ends_with?(dn)
      needle = LDAP::Server::Operation.split_dn(dn)

      # Needle is longer than haystack
      return false if needle.length > @dname.length

      needle_index = needle.length - 1
      haystack_index = @dname.length - 1

      while needle_index >= 0
        return false if @dname[haystack_index] != needle[needle_index]
        needle_index -= 1
        haystack_index -= 1
      end
      return true
    end
  end
end
