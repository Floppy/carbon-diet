class BelongsToUser < AuthenticatedController
  before_filter :get_user

protected

  def get_user
    @user = User.find_by_login(params[:user_id])
    raise ActiveRecord::RecordNotFound if @user.nil?
    raise ActionController::PermissionDenied unless @user == @current_user || @current_user.admin
  end

end
