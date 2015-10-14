class EmailAliasesController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  layout "dashboard"

  # GET /emailaliases
  def index
    authorize! :list, EmailAlias
  end

  # POST /emailaliases
  def create
    authorize! :create, EmailAlias

    @emailalias = EmailAlias.new(emailalias_params)
    if @emailalias.save
      redirect_to emailaliases_path
    else
      render 'new'
    end
  end

  # GET /emailaliases/new
  def new
    authorize! :create, EmailAlias
    @emailalias = EmailAlias.new
  end

  # GET /emailaliases/:id/edit
  def edit
    @emailalias = EmailAlias.find(params[:id])
    authorize! :update, @emailalias
  end

  # PUT/PATCH /emailaliases/:id
  def update
    @emailalias = EmailAlias.find(params[:id])
    authorize! :update, @emailalias

    if @emailalias.update(emailalias_params)
      redirect_to emails_path
    else
      render 'edit'
    end
  end

  # DELETE /emailaliases/:id
  def destroy
    @emailalias = EmailAlias.find(params[:id])
    authorize! :destroy, @emailalias

    @emailalias.destroy

    redirect_to emails_path
  end

  # Allowed parameters
  protected
  def emailalias_params
     params.require(:email_alias).permit(:alias,
                                          :mail)
  end
end
