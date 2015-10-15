class DomainAliasesController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  layout "dashboard"

  # GET /domain_aliases
  def index
    authorize! :list, DomainAlias
  end

  # POST /domain_aliases
  def create
    authorize! :create, DomainAlias

    @domain_alias = DomainAlias.new(domain_alias_params)
    if @domain_alias.save
      redirect_to domain_aliases_path
    else
      render 'new'
    end
  end

  # GET /domain_aliases/new
  def new
    authorize! :create, DomainAlias
    @domain_alias = DomainAlias.new
  end

  # GET /domain_aliases/:id/edit
  def edit
    @domain_alias = DomainAlias.find(params[:id])
    authorize! :update, @domain_alias
  end

  # PUT/PATCH /domain_aliases/:id
  def update
    @domain_alias = DomainAlias.find(params[:id])
    authorize! :update, @domain_alias

    if @domain_alias.update(domain_alias_params)
      redirect_to domains_path
    else
      render 'edit'
    end
  end

  # DELETE /domain_aliases/:id
  def destroy
    @domain_alias = DomainAlias.find(params[:id])
    authorize! :destroy, @domain_alias

    @domain_alias.destroy

    redirect_to domains_path
  end

  # Allowed parameters
  protected
  def domain_alias_params
    params.require(:domain_alias).permit(:alias,
                                          :domain)
  end
end
