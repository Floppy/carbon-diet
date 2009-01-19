class BelongsToUser < AuthenticatedController
  before_filter :get_user

protected

  def get_user
    @user = User.find_by_login(params[:user_id])
    if @user.nil?
      render_http_code 404
    elsif @user != @current_user && !@user.admin
      render_http_code 401
    end
  end

end
