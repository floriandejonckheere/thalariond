class EmailsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource :domain, :except => [:new_blank, :create]
  load_and_authorize_resource :email, :through => :domain, :except => [:new_blank, :create]

  layout 'dashboard'

  def create
    authorize! :create, Email
    @domain = Domain.find(params[:email][:domain_id]) unless @domain

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

  def new_blank
    authorize! :create, Email
    @email = Email.new
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
                                    :domain_id)
  end
end
