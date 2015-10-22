class GroupsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource
  skip_authorization_check :only => :index

  layout "dashboard"

  def index
  end

  def create
    if @group.save
      redirect_to @group
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
    if @group.update(group_params)
      redirect_to group_path(@group)
    else
      render 'edit'
    end
  end

  def destroy
    flash[:info] = "Group '#{@group.display_name}' deleted"
    @group.destroy
    redirect_to groups_path
  end

  private
  def group_params
     params.require(:group).permit(:name, :display_name, :user_id)
  end

end
