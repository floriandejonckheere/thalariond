class DomainAliasesController < ApplicationController
  before_filter :authenticate_user!

  load_resource

  layout "dashboard"

  def create
    authorize! :create, DomainAlias

    @domain_alias = DomainAlias.new(domain_alias_params)
    if @domain_alias.save
      redirect_to domains_path(:anchor => 'domain_aliases')
    else
      render 'new'
    end
  end

  def new
    authorize! :create, DomainAlias
  end

  def edit
    authorize! :update, @domain_alias
  end

  def show
    authorize! :read, @domain_alias
  end

  def update
    authorize! :update, @domain_alias

    if @domain_alias.update(domain_alias_params)
      redirect_to domain_alias_path(@domain_alias)
    else
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @domain_alias

    @domain_alias.destroy
    redirect_to domains_path(:anchor => 'domain_aliases')
  end

  private
  def domain_alias_params
    params.require(:domain_alias).permit(:alias,
                                          :domain)
  end
end
