# Adds an 'account' attribute to the client connection

module LDAP
class Server

  class Connection
    def account
      @account
    end

    def ability
      @ability
    end

    def account=(account)
      @account = account
      @ability = Ability.new account
    end
  end

end
end
