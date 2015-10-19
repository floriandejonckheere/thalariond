module GroupsHelper

  def permission_group?
    return false if @group.name.nil?
    split = @group.name.split('@')
    return false if split.length != 2
    domain = Domain.find_by(domain: split[1])
    return false if domain.nil?
    email = Email.find_by(domain: domain, mail: split[0])
    return false if email.nil?
    true
  end

end
