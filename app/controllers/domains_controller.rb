class DomainsController < ApplicationController
  before_filter :authenticate_user!

  load_resource

  layout "dashboard"

  def index
    @domain_aliases = DomainAlias.accessible_by(current_ability)
  end

  def create
    authorize! :create, Domain

    @domain = Domain.new(domain_params)
    if @domain.save
      redirect_to domains_path
    else
      render 'new'
    end
  end

  def new
    authorize! :create, Domain
  end

  def edit
    authorize! :update, @domain
  end

  def show
    authorize! :read, @domain
    @domain_aliases = DomainAlias.where(domain: @domain.domain)
  end

  def update
    authorize! :update, @domain

    if @domain.update(domain_params)
      redirect_to domain_path(@domain)
    else
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @domain

    @domain.destroy
    redirect_to domains_path
  end

  private
  def domain_params
     params.require(:domain).permit(:domain)
  end
end
