class EmailsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource :domain
  load_and_authorize_resource :email, :through => :domain

  layout "dashboard"

  def create
    authorize! :create, Email

    @email = @domain.emails.build(params[:email])
    if @email.save
      redirect_to domain_email_path(@domain, @email)
    else
      render 'new'
    end
  end

  def new
    authorize! :create, Email

    @email = @domain.emails.build
  end

  def edit
    authorize! :update, @email
  end

  def show
    authorize! :read, @email
    @email_aliases = EmailAlias.where(mail: @email.mail)
    @permission_group = Group.find_by(name: @email.to_s)
  end

  def update
    authorize! :update, @email

    if @email.update(email_params)
      redirect_to domain_email_path(@domain, @email)
    else
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @email

    flash[:info] = "Email '#{@email.to_s}' deleted"
    @email.destroy
    redirect_to domain_email_path(@domain, @email)
  end

  private
  def email_params
     params.require(:email).permit(:mail)
  end
end
