class MailController < ApplicationController
  before_action :authenticate_user!

  skip_authorization_check

  layout 'dashboard'

  def index
    authorize! :read, Email
    authorize! :read, Domain
    @emails = Email.accessible_by(current_ability).order :mail
    @email_aliases = EmailAlias.accessible_by(current_ability).order :alias
  end
end
