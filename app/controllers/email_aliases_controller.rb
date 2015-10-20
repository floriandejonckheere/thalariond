class EmailAliasesController < ApplicationController
  before_filter :authenticate_user!

  load_resource

  layout "dashboard"

  def create
    authorize! :create, EmailAlias

    @email_alias = EmailAlias.new(email_alias_params)
    if @email_alias.save
      redirect_to mail_path(:anchor => 'email_aliases')
    else
      render 'new'
    end
  end

  def new
    authorize! :create, EmailAlias
  end

  def edit
    authorize! :update, @email_alias
  end

  def show
    authorize! :read, @email_alias
  end

  def update
    authorize! :update, @email_alias

    if @email_alias.update(email_alias_params)
      redirect_to email_alias_path(@email_alias)
    else
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @email_alias

    flash[:info] = "Email alias deleted"
    @email_alias.destroy
    redirect_to mail_path(:anchor => 'email_aliases')
  end

  private
  def email_alias_params
     params.require(:email_alias).permit(:alias,
                                          :mail)
  end
end
