class Admin::AdminController < ApplicationController
  before_filter :admin_logged_in

  def admin_logged_in
    user = get_current_user
    unless user and user.admin
      render :text => "Not Admin - Access Denied", :status => 401
      return
    end
  end
  
end
