class EmailAliasesController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  layout "dashboard"

  def create
    if @email_alias.save
      redirect_to mail_path(:anchor => 'email_aliases')
    else
      render 'new'
    end
  end

  def new
  end

  def edit
  end

  def show
  end

  def update
    if @email_alias.update(email_alias_params)
      redirect_to email_alias_path(@email_alias)
    else
      render 'edit'
    end
  end

  def destroy
    flash[:info] = "Email alias '#{@email_alias.alias}' deleted"
    @email_alias.destroy
    redirect_to mail_path(:anchor => 'email_aliases')
  end

  private
  def email_alias_params
     params.require(:email_alias).permit(:alias,
                                          :mail)
  end
end
