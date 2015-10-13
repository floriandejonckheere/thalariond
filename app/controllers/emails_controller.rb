class EmailsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  layout "dashboard"

  # POST /emails
  def create
    authorize! :create, Email

    @email = Email.new(email_params)
    if @email.save
      redirect_to domain_emails_path(@email.domain)
    else
      render 'new'
    end
  end

  # GET /emails/new
  def new
    authorize! :create, Email
    @email = Email.new
  end

  # GET /emails/:id/edit
  def edit
    @email = Email.find(params[:id])
    authorize! :update, @email
  end

  # PUT/PATCH /emails/:id
  def update
    @email = Email.find(params[:id])
    authorize! :update, @email

    if @email.update(email_params)
      redirect_to domain_emails_path(@email.domain)
    else
      render 'edit'
    end
  end

  # DELETE /emails/:id
  def destroy
    @email = Email.find(params[:id])
    authorize! :delete, @email

    @email.destroy

    redirect_to domain_emails_path(@email.domain)
  end

  # Allowed parameters
  protected
  def email_params
     params.require(:email).permit(:mail,
                                    :domain_id)
  end
end
