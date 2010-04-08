class GroupInvitationsController < ApplicationController
  before_filter :check_logged_in
  before_filter :get_group

  def new
    @friends = Array.new(@current_user.friends)
    @group.users.each do |user|
      @friends.delete(user)
    end
  end

  def create
    @current_user.friends.each do |friend|
      if params[:invite][friend.login] == "1"
        # Create invitation - automatically notifies the invited person
        GroupInvitation.create(:user => friend, :inviter => @current_user, :group => @group)
      end
    end
    flash[:notice] = "Invitations sent!"
    redirect_to group_path(@group)
  end

  def update
    invitation = @current_user.group_invitations.find(params[:id])
    invitation.accept
    redirect_to user_groups_path(@current_user)
  rescue
    flash[:notice] = "Unknown invitation ID!"
    redirect_to user_groups_path(@current_user)
  end

  def destroy
    invitation = @current_user.group_invitations.find(params[:id])
    invitation.reject
    redirect_to user_groups_path(@current_user)
  rescue
    flash[:notice] = "Unknown invitation ID!"
    redirect_to user_groups_path(@current_user)
  end

protected

  def get_group
    @group = Group.find_by_name(params[:group_id])
    raise ActiveRecord::RecordNotFound if @group.nil?
  end
end