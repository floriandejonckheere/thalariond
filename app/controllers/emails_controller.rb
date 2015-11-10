class EmailsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource :domain
  load_and_authorize_resource :email, :through => :domain

  layout "dashboard"

  def create
    @email = @domain.emails.build(params[:email])
    if @email.save
      redirect_to domain_email_path(@domain, @email)
    else
      render 'new'
    end
  end

  def new
    @email = @domain.emails.build
  end

  def edit
  end

  def show
  end

  def update
    if @email.update(email_params)
      redirect_to domain_email_path(@domain, @email)
    else
      render 'edit'
    end
  end

  def destroy
    flash[:info] = "Email '#{@email.to_s}' deleted"
    @email.destroy
    redirect_to domain_path(@domain)
  end

  private
  def email_params
     params.require(:email).permit(:mail,
                                    :group)
  end
end
