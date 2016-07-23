class DomainAliasesController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  layout 'dashboard'

  def create
    if @domain_alias.save
      redirect_to domains_path(:anchor => 'domain_aliases')
    else
      render 'new'
    end
  end

  def new
  end

  def edit
  end

  def show
  end

  def update
    if @domain_alias.update(domain_alias_params)
      redirect_to domain_alias_path(@domain_alias)
    else
      render 'edit'
    end
  end

  def destroy
    flash[:info] = "Domain alias '#{@domain_alias.alias}' deleted"
    @domain_alias.destroy
    redirect_to domains_path(:anchor => 'domain_aliases')
  end

  private
  def domain_alias_params
    params.require(:domain_alias).permit(:alias,
                                          :domain)
  end
end
