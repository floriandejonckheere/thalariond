class DomainAliasAliasesController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  layout "dashboard"

  # GET /domainaliases
  def index
    authorize! :list, DomainAlias
  end

  # POST /domainaliases
  def create
    authorize! :create, DomainAlias

    @domainalias = DomainAlias.new(domainalias_params)
    if @domainalias.save
      redirect_to domainaliases_path
    else
      render 'new'
    end
  end

  # GET /domainaliases/new
  def new
    authorize! :create, DomainAlias
    @domainalias = DomainAlias.new
  end

  # GET /domainaliases/:id/edit
  def edit
    @domainalias = DomainAlias.find(params[:id])
    authorize! :update, @domainalias
  end

  # PUT/PATCH /domainaliases/:id
  def update
    @domainalias = DomainAlias.find(params[:id])
    authorize! :update, @domainalias

    if @domainalias.update(domainalias_params)
      redirect_to domains_path
    else
      render 'edit'
    end
  end

  # DELETE /domainaliases/:id
  def destroy
    @domainalias = DomainAlias.find(params[:id])
    authorize! :delete, @domainalias

    @domainalias.destroy

    redirect_to domains_path
  end

  # Allowed parameters
  protected
  def domainalias_params
     params.require(:domain_alias).permit(:alias,
                                          :domain)
  end
end
