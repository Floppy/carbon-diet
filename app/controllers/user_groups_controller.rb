class UserGroupsController < BelongsToUser
  before_filter :get_group, :except => [:index]

  def index
    @groups = @user.groups
  end
  
  def destroy
    @group.remove_user @user
    redirect_to user_groups_path(@user)
  end

  def create
    @group.add_user @user
    redirect_to group_path(@group)
  end

end
