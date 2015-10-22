class MailController < ApplicationController
  before_filter :authenticate_user!

  skip_authorization_check

  layout "dashboard"

  def index
    @emails = Email.accessible_by(current_ability)
    @email_aliases = EmailAlias.accessible_by(current_ability)
  end

end
