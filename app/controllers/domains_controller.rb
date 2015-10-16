class DomainsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  layout "dashboard"

  # POST /domains
  def create
    authorize! :create, Domain

    @domain = Domain.new(domain_params)
    if @domain.save
      redirect_to domains_path
    else
      render 'new'
    end
  end

  # GET /domains/new
  def new
    authorize! :create, Domain
    @domain = Domain.new
  end

  # GET /domains/:id/edit
  def edit
    @domain = Domain.find(params[:id])
    authorize! :update, @domain
  end

  # PUT/PATCH /domains/:id
  def update
    @domain = Domain.find(params[:id])
    authorize! :update, @domain

    if @domain.update(domain_params)
      redirect_to domain_path(@domain)
    else
      render 'edit'
    end
  end

  # DELETE /domains/:id
  def destroy
    @domain = Domain.find(params[:id])
    authorize! :destroy, @domain

    @domain.destroy

    redirect_to mail_path
  end

  # Allowed parameters
  protected
  def domain_params
     params.require(:domain).permit(:domain)
  end
end
