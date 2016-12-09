class GroupsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource
  skip_authorization_check :only => :index

  layout 'dashboard'

  # If you're experiencing a ForbiddenAttributesError, check out before_action in application_controller

  def index
    @regular_groups = Group.where(:email => nil).accessible_by(current_ability).order :name
    @permission_groups = Group.where.not(:email => nil).accessible_by(current_ability).order :name

    @member_groups = current_user.groups.order :name
    @owned_groups = current_user.owned_groups.order :name
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
    @users_not_in_group = User.order(:uid).select { |u| current_user.can? :read, u } - @group.users
    @services_not_in_group = Service.order(:uid).select { |s| current_user.can? :read, s } - @group.services
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
