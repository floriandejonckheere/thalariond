class GroupsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource
  skip_authorization_check :only => :index

  layout 'dashboard'

  # If you're experiencing a ForbiddenAttributesError, check out before_filter in application_controller

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
    @users = User.accessible_by(current_ability).select { |u| can? :read, u }
    @services = Service.accessible_by(current_ability).select { |s| can? :read, s }
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
     params.require(:group).permit(:name,
                                    :display_name,
                                    :user_id,
                                    :email_id)
  end

end
