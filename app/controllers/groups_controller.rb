class GroupsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  layout "dashboard"

  # GET /groups
  def index
    # Everyone can access the index page,
    # authorization for :list is handled
    # in the view.
  end

  # POST /groups
  def create
    authorize! :create, Group

    @group = Group.new(group_params)
    if @group.save
      redirect_to @group
    else
      render 'new'
    end
  end

  # GET /groups/new
  def new
    authorize! :create, Group
    @group = Group.new
  end

  # GET /groups/:id/edit
  def edit
    @group = Group.find(params[:id])
    authorize! :update, @group
  end

  # GET /groups/:id
  def show
    @group = Group.find(params[:id])
    authorize! :read, @group
  end

  # PUT/PATCH /groups/:id
  def update
    @group = Group.find(params[:id])
    authorize! :update, @group

    if @group.update(group_params)
      redirect_to groups_path
    else
      render 'edit'
    end
  end

  # DELETE /groups/:id
  def destroy
    @group = Group.find(params[:id])
    authorize! :destroy, @group

    @group.destroy

    redirect_to groups_path
  end

  # Allowed parameters
  private
  def group_params
     params.require(:group).permit(:name, :display_name, :owner)
  end

end
