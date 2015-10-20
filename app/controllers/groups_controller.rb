class GroupsController < ApplicationController
  before_filter :authenticate_user!

  load_resource

  layout "dashboard"

  def index
  end

  def create
    authorize! :create, Group

    @group = Group.new(group_params)
    if @group.save
      redirect_to @group
    else
      render 'new'
    end
  end

  def new
    authorize! :create, Group
  end

  def edit
    authorize! :update, @group
  end

  def show
    authorize! :read, @group
  end

  def update
    authorize! :update, @group

    if @group.update(group_params)
      redirect_to group_path(@group)
    else
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @group

    flash[:info] = "Group deleted"
    @group.destroy
    redirect_to groups_path
  end

  private
  def group_params
     params.require(:group).permit(:name, :display_name, :user_id)
  end

end
