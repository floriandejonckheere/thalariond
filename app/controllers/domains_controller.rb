class DomainsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource
  skip_authorization_check :only => :index

  layout 'dashboard'

  def index
    @domains = Domain.accessible_by(current_ability).order :domain
    @domain_aliases = DomainAlias.accessible_by(current_ability).order :domain
    @domains_and_aliases = (@domains + @domain_aliases).sort_by &:domain
  end

  def create
    if @domain.save
      redirect_to domains_path
    else
      render 'new'
    end
  end

  def new
  end

  def edit
  end

  def show
    @domain_aliases = DomainAlias.where :domain => @domain.domain
  end

  def update
    if @domain.update(domain_params)
      redirect_to domain_path(@domain)
    else
      render 'edit'
    end
  end

  def destroy
    flash[:info] = "Domain '#{@domain.domain}' deleted"
    @domain.destroy
    redirect_to domains_path
  end

  private
  def domain_params
     params.require(:domain).permit(:domain)
  end
end
